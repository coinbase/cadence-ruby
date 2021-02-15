require 'cadence/workflow/decision_task_processor'
require 'cadence/workflow'
require 'cadence/executable_lookup'
require 'cadence/client/thrift_client'
require 'cadence/middleware/chain'

describe Cadence::Workflow::DecisionTaskProcessor do
  class TestWorkflow < Cadence::Workflow; end

  subject { described_class.new(task, domain, lookup, client, middleware_chain) }

  let(:task) { Fabricate(:decision_task_thrift) }
  let(:domain) { 'test-domain' }
  let(:lookup) { Cadence::ExecutableLookup.new }
  let(:client) do
    instance_double(
      Cadence::Client::ThriftClient,
      respond_decision_task_completed: nil,
      respond_decision_task_failed: nil
    )
  end
  let(:middleware_chain) { Cadence::Middleware::Chain.new }
  let(:executor) { instance_double(Cadence::Workflow::Executor, run: []) }

  before do
    allow(Cadence.metrics).to receive(:timing)
    allow(Cadence.logger).to receive(:info)
    allow(Cadence.logger).to receive(:error)
    allow(Cadence.logger).to receive(:debug)
  end

  context 'when workflow is registered' do
    before do
      lookup.add('TestWorkflow', TestWorkflow)

      allow(Cadence::Workflow::Executor)
        .to receive(:new)
        .with(TestWorkflow, an_instance_of(Cadence::Workflow::History))
        .and_return(executor)
    end

    it 'runs the workflow executor' do
      subject.process

      expect(Cadence::Workflow::Executor).to have_received(:new) do |workflow_class, history|
        expect(workflow_class).to eq(TestWorkflow)
        expect(history.events.length).to eq(5)
      end

      expect(executor).to have_received(:run)
    end

    it 'invokes the middleware chain' do
      allow(middleware_chain).to receive(:invoke).and_call_original

      subject.process

      expect(middleware_chain).to have_received(:invoke)
    end

    it 'completes the decision task' do
      subject.process

      expect(client)
        .to have_received(:respond_decision_task_completed)
        .with(task_token: task.taskToken, decisions: [])
    end

    it 'emits latency metrics' do
      subject.process

      expect(Cadence.metrics)
        .to have_received(:timing)
        .with('decision_task.queue_time', an_instance_of(Integer), workflow: 'TestWorkflow')

      expect(Cadence.metrics)
        .to have_received(:timing)
        .with('decision_task.latency', an_instance_of(Integer), workflow: 'TestWorkflow')
    end

    context 'when history is paginated' do
      let(:task) { Fabricate(:decision_task_thrift, nextPageToken: 'token-1') }
      let(:history_1) { Fabricate(:worklfow_execution_history_thrift, nextPageToken: 'token-2') }
      let(:history_2) { Fabricate(:worklfow_execution_history_thrift, nextPageToken: nil) }

      before do
        allow(client)
          .to receive(:get_workflow_execution_history)
          .and_return(history_1, history_2)
      end

      it 'fetches missing history pages' do
        subject.process

        expect(client)
          .to have_received(:get_workflow_execution_history)
          .with(
            domain: domain,
            workflow_id: task.workflowExecution.workflowId,
            run_id: task.workflowExecution.runId,
            next_page_token: task.nextPageToken
          )

        expect(client)
          .to have_received(:get_workflow_execution_history)
          .with(
            domain: domain,
            workflow_id: task.workflowExecution.workflowId,
            run_id: task.workflowExecution.runId,
            next_page_token: history_1.nextPageToken
          )
      end

      it 'passes full history to the workflow executor' do
        subject.process

        expect(Cadence::Workflow::Executor).to have_received(:new) do |workflow_class, history|
          expect(workflow_class).to eq(TestWorkflow)
          expect(history.events.length).to eq(15)
        end
      end
    end

    context 'when unable to complete a workflow' do
      before do
        allow(client)
          .to receive(:respond_decision_task_completed)
          .and_raise(StandardError, 'Host unreachable')
      end

      it 'does not raise' do
        expect { subject.process }.not_to raise_error
      end

      it 'logs the error' do
        subject.process

        expect(Cadence.logger)
          .to have_received(:error)
          .with("Decison task for TestWorkflow failed with: #<StandardError: Host unreachable>")
      end
    end
  end

  context 'when workflow class is not registered' do
    it 'fails the decision task' do
      subject.process

      expect(client)
        .to have_received(:respond_decision_task_failed)
        .with(
          task_token: task.taskToken,
          cause: CadenceThrift::DecisionTaskFailedCause::UNHANDLED_DECISION,
          details: { message: 'Workflow does not exist' }
        )
    end

    it 'emits latency metrics' do
      subject.process

      expect(Cadence.metrics)
        .to have_received(:timing)
        .with('decision_task.queue_time', an_instance_of(Integer), workflow: 'TestWorkflow')

      expect(Cadence.metrics)
        .to have_received(:timing)
        .with('decision_task.latency', an_instance_of(Integer), workflow: 'TestWorkflow')
    end
  end
end
