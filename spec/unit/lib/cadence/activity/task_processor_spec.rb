require 'cadence/activity/task_processor'
require 'cadence/middleware/chain'
require 'cadence/configuration'

describe Cadence::Activity::TaskProcessor do
  subject { described_class.new(task, domain, lookup, middleware_chain, config) }

  let(:domain) { 'test-domain' }
  let(:lookup) { instance_double('Cadence::ExecutableLookup', find: nil) }
  let(:task) do
    Fabricate(:activity_task_thrift, activity_name: activity_name, input: Cadence::JSON.serialize(input))
  end
  let(:metadata) { Cadence::Metadata.generate(Cadence::Metadata::ACTIVITY_TYPE, task, domain) }
  let(:activity_name) { 'TestActivity' }
  let(:connection) { instance_double('Cadence::Connection::Thrift') }
  let(:middleware_chain) { Cadence::Middleware::Chain.new }
  let(:config) { Cadence::Configuration.new }
  let(:input) { ['arg1', 'arg2'] }

  describe '#process' do
    let(:context) { instance_double('Cadence::Activity::Context', async?: false) }

    before do
      allow(Cadence::Connection)
        .to receive(:generate)
        .with(config.for_connection)
        .and_return(connection)
      allow(Cadence::Metadata)
        .to receive(:generate)
        .with(Cadence::Metadata::ACTIVITY_TYPE, task, domain)
        .and_return(metadata)
      allow(Cadence::Activity::Context).to receive(:new).with(connection, metadata).and_return(context)
      allow(Cadence::ErrorHandler).to receive(:handle)

      allow(connection).to receive(:respond_activity_task_completed)
      allow(connection).to receive(:respond_activity_task_failed)

      allow(middleware_chain).to receive(:invoke).and_call_original

      allow(Cadence.metrics).to receive(:timing)
    end

    context 'when activity is not registered' do
      it 'fails the activity task' do
        subject.process

        expect(connection)
          .to have_received(:respond_activity_task_failed)
          .with(
            task_token: task.taskToken,
            reason: 'ActivityNotRegistered',
            details: 'Activity is not registered with this worker'
          )
      end

      it 'ignores connection exception' do
        allow(connection)
          .to receive(:respond_activity_task_failed)
          .and_raise(StandardError)

        subject.process
      end
    end

    context 'when activity is registered' do
      let(:activity_class) { double('Cadence::Activity', execute_in_context: nil) }

      before do
        allow(lookup).to receive(:find).with(activity_name).and_return(activity_class)
      end

      context 'when activity completes' do
        before { allow(activity_class).to receive(:execute_in_context).and_return('result') }

        it 'runs the specified activity' do
          subject.process

          expect(activity_class).to have_received(:execute_in_context).with(context, input)
        end

        it 'invokes the middleware chain' do
          subject.process

          expect(middleware_chain).to have_received(:invoke).with(metadata)
        end

        it 'completes the activity task' do
          subject.process

          expect(connection)
            .to have_received(:respond_activity_task_completed)
            .with(task_token: task.taskToken, result: 'result')
        end

        it 'ignores connection exception' do
          allow(connection)
            .to receive(:respond_activity_task_completed)
            .and_raise(StandardError)

          subject.process
        end

        it 'sends queue_time metric' do
          subject.process

          expect(Cadence.metrics)
            .to have_received(:timing)
            .with('activity_task.queue_time', an_instance_of(Integer), activity: activity_name)
        end

        it 'sends latency metric' do
          subject.process

          expect(Cadence.metrics)
            .to have_received(:timing)
            .with('activity_task.latency', an_instance_of(Integer), activity: activity_name)
        end

        context 'with async activity' do
          before { allow(context).to receive(:async?).and_return(true) }

          it 'does not complete the activity task' do
            subject.process

            expect(connection).not_to have_received(:respond_activity_task_completed)
          end
        end
      end

      context 'when activity raises an exception' do
        let(:exception) { StandardError.new('activity failed') }

        before { allow(activity_class).to receive(:execute_in_context).and_raise(exception) }

        it 'runs the specified activity' do
          subject.process

          expect(activity_class).to have_received(:execute_in_context).with(context, input)
        end

        it 'invokes the middleware chain' do
          subject.process

          expect(middleware_chain).to have_received(:invoke).with(metadata)
        end

        it 'fails the activity task' do
          subject.process

          expect(connection)
            .to have_received(:respond_activity_task_failed)
            .with(
              task_token: task.taskToken,
              reason: exception.class.name,
              details: exception.message
            )
        end

        it 'ignores connection exception' do
          allow(connection)
            .to receive(:respond_activity_task_failed)
            .and_raise(StandardError, 'connection failure')

          subject.process

          expect(Cadence::ErrorHandler)
            .to have_received(:handle)
            .twice
            .with(StandardError, metadata: metadata)
        end

        it 'sends queue_time metric' do
          subject.process

          expect(Cadence.metrics)
            .to have_received(:timing)
            .with('activity_task.queue_time', an_instance_of(Integer), activity: activity_name)
        end

        it 'sends latency metric' do
          subject.process

          expect(Cadence.metrics)
            .to have_received(:timing)
            .with('activity_task.latency', an_instance_of(Integer), activity: activity_name)
        end

        it 'calls error handlers' do
          subject.process

          expect(Cadence::ErrorHandler)
            .to have_received(:handle)
            .with(exception, metadata: metadata)
        end

        context 'with ScriptError exception' do
          let(:exception) { NotImplementedError.new('this was not supposed to be called') }

          it 'fails the activity task' do
            subject.process

            expect(connection)
              .to have_received(:respond_activity_task_failed)
              .with(
                task_token: task.taskToken,
                reason: exception.class.name,
                details: exception.message
              )
          end
        end

        context 'with SystemExit exception' do
          let(:exception) { SystemExit.new('Houston, we have a problem') }

          it 'does not handle the exception' do
            expect { subject.process }.to raise_error(exception)

            expect(connection).not_to have_received(:respond_activity_task_failed)
          end
        end

        context 'with async activity' do
          before { allow(context).to receive(:async?).and_return(true) }

          it 'fails the activity task' do
            subject.process

            expect(connection)
              .to have_received(:respond_activity_task_failed)
              .with(task_token: task.taskToken, reason: 'StandardError', details: 'activity failed')
          end
        end
      end
    end
  end
end
