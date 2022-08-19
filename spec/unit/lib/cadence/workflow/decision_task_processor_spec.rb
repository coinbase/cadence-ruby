require 'cadence/workflow/decision_task_processor'
require 'cadence/workflow'
require 'cadence/metadata'
require 'cadence/executable_lookup'
require 'cadence/connection/thrift'
require 'cadence/middleware/chain'
require 'cadence/configuration'

describe Cadence::Workflow::DecisionTaskProcessor do
  class TestWorkflow < Cadence::Workflow; end

  subject { described_class.new(task, domain, lookup, middleware_chain, config) }

  let(:query) { nil }
  let(:queries) { nil }
  let(:task) { Fabricate(:decision_task_thrift, { workflowType: :workflow_type_thrift, query: query, queries: queries }.compact) }
  # let(:task) { Fabricate(:decision_task_thrift) }
  let(:workflow_type_thrift) { Fabricate(:workflow_type_thrift, name: workflow_name) }
  let(:workflow_name) { 'TestWorkflow' }
  let(:domain) { 'test-domain' }
  let(:lookup) { Cadence::ExecutableLookup.new }
  let(:connection) do
    instance_double(
      Cadence::Connection::Thrift,
      respond_decision_task_completed: nil,
      respond_decision_task_failed: nil
    )
  end
  let(:metadata) { Cadence::Metadata.generate(Cadence::Metadata::DECISION_TYPE, task, domain) }
  let(:middleware_chain) { Cadence::Middleware::Chain.new }
  let(:executor) { instance_double(Cadence::Workflow::Executor, run: []) }
  let(:config) { Cadence::Configuration.new }

  before do
    allow(Cadence::Connection)
      .to receive(:generate)
      .with(config.for_connection)
      .and_return(connection)
    allow(Cadence.metrics).to receive(:timing)
    allow(Cadence.logger).to receive(:info)
    allow(Cadence.logger).to receive(:error)
    allow(Cadence.logger).to receive(:debug)
    allow(Cadence::ErrorHandler).to receive(:handle)
    allow(connection).to receive(:respond_query_task_completed)
    allow(Cadence::Metadata)
      .to receive(:generate)
      .with(Cadence::Metadata::DECISION_TYPE, task, domain)
      .and_return(metadata)
  end

  context 'when workflow is registered' do
    before do
      lookup.add('TestWorkflow', TestWorkflow)

      allow(Cadence::Workflow::Executor)
        .to receive(:new)
        .with(TestWorkflow, an_instance_of(Cadence::Workflow::History), metadata, config)
        .and_return(executor)
      allow(executor).to receive(:process_queries)
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

      expect(connection)
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
        allow(connection)
          .to receive(:get_workflow_execution_history)
          .and_return(history_1, history_2)
      end

      it 'fetches missing history pages' do
        subject.process

        expect(connection)
          .to have_received(:get_workflow_execution_history)
          .with(
            domain: domain,
            workflow_id: task.workflowExecution.workflowId,
            run_id: task.workflowExecution.runId,
            next_page_token: task.nextPageToken
          )

        expect(connection)
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
        allow(connection)
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
          .with("Unable to complete Decision task TestWorkflow: #<StandardError: Host unreachable>")
      end

      it 'calls error handlers' do
        subject.process

        expect(Cadence::ErrorHandler)
          .to have_received(:handle)
          .with(StandardError, metadata: metadata)
      end
    end
  end

  context 'when workflow class is not registered' do
    it 'fails the decision task' do
      subject.process

      expect(connection)
        .to have_received(:respond_decision_task_failed)
        .with(
          task_token: task.taskToken,
          cause: CadenceThrift::DecisionTaskFailedCause::UNHANDLED_DECISION,
          details: 'Workflow does not exist'
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

  context 'when decision task has reached max attempts' do
    let(:task) { Fabricate(:decision_task_thrift, attempt: described_class::MAX_FAILED_ATTEMPTS) }

    it 'does not notify Cadence' do
      allow(executor).to receive(:run).and_raise(StandardError, 'Something went horribly wrong')

      subject.process

      expect(connection).not_to have_received(:respond_decision_task_failed)
    end
  end

  context 'when workflow task queries are included' do
    let(:query_id) { SecureRandom.uuid }
    let(:query_result) { Cadence::Workflow::QueryResult.answer(42) }

    let(:queries) do
    end
    CadenceThrift::Map.new(:string, :message, CadenceThrift::WorkflowQuery).tap do |map|
        map[query_id] = Fabricate(:api_workflow_query)
      end
    end
end
