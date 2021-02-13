require 'cadence/workflow/poller'
require 'cadence/middleware/entry'

describe Cadence::Workflow::Poller do
  let(:client) { instance_double('Cadence::Client::ThriftClient') }
  let(:domain) { 'test-domain' }
  let(:task_list) { 'test-task-list' }
  let(:lookup) { instance_double('Cadence::ExecutableLookup') }
  let(:middleware_chain) { instance_double(Cadence::Middleware::Chain) }
  let(:middleware) { [] }

  subject { described_class.new(domain, task_list, lookup, middleware) }

  before do
    allow(Cadence::Client).to receive(:generate).and_return(client)
    allow(Cadence::Middleware::Chain).to receive(:new).and_return(middleware_chain)
    allow(Cadence.metrics).to receive(:timing)
  end

  describe '#start' do
    it 'polls for decision tasks' do
      allow(subject).to receive(:shutting_down?).and_return(false, false, true)
      allow(client).to receive(:poll_for_decision_task).and_return(nil)

      subject.start

      # stop poller before inspecting
      subject.stop; subject.wait

      expect(client)
        .to have_received(:poll_for_decision_task)
        .with(domain: domain, task_list: task_list)
        .twice
    end

    it 'polls for decision tasks' do
      allow(subject).to receive(:shutting_down?).and_return(false, false, true)
      allow(client).to receive(:poll_for_decision_task).and_return(nil)

      subject.start

      # stop poller before inspecting
      subject.stop; subject.wait

      expect(Cadence.metrics)
        .to have_received(:timing)
        .with(
          'workflow_poller.time_since_last_poll',
          an_instance_of(Fixnum),
          domain: domain,
          task_list: task_list
        )
        .twice
    end

    context 'when an decision task is received' do
      let(:task_processor) do
        instance_double(Cadence::Workflow::DecisionTaskProcessor, process: nil)
      end
      let(:task) { Fabricate(:decision_task_thrift) }

      before do
        allow(subject).to receive(:shutting_down?).and_return(false, true)
        allow(client).to receive(:poll_for_decision_task).and_return(task)
        allow(Cadence::Workflow::DecisionTaskProcessor).to receive(:new).and_return(task_processor)
      end

      it 'uses DecisionTaskProcessor to process tasks' do
        subject.start

        # stop poller before inspecting
        subject.stop; subject.wait

        expect(Cadence::Workflow::DecisionTaskProcessor)
          .to have_received(:new)
          .with(task, domain, lookup, client, middleware_chain)
        expect(task_processor).to have_received(:process)
      end

      context 'with middleware configured' do
        class TestPollerMiddleware
          def initialize(_); end
          def call(_); end
        end

        let(:middleware) { [entry_1, entry_2] }
        let(:entry_1) { Cadence::Middleware::Entry.new(TestPollerMiddleware, '1') }
        let(:entry_2) { Cadence::Middleware::Entry.new(TestPollerMiddleware, '2') }

        it 'initializes middleware chain and passes it down to DecisionTaskProcessor' do
          subject.start

          # stop poller before inspecting
          subject.stop; subject.wait

          expect(Cadence::Middleware::Chain).to have_received(:new).with(middleware)
          expect(Cadence::Workflow::DecisionTaskProcessor)
            .to have_received(:new)
            .with(task, domain, lookup, client, middleware_chain)
        end
      end
    end

    context 'when client is unable to poll' do
      before do
        allow(subject).to receive(:shutting_down?).and_return(false, true)
        allow(client).to receive(:poll_for_decision_task).and_raise(StandardError)
      end

      it 'logs' do
        allow(Cadence.logger).to receive(:error)

        subject.start

        # stop poller before inspecting
        subject.stop; subject.wait

        expect(Cadence.logger)
          .to have_received(:error)
          .with('Unable to poll for a decision task: #<StandardError: StandardError>')
      end
    end
  end
end
