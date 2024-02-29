require 'cadence/workflow/state_manager'
require 'cadence/workflow/decision'
require 'cadence/workflow/dispatcher'
require 'cadence/errors'

describe Cadence::Workflow::StateManager do
  subject { described_class.new(dispatcher) }

  let(:dispatcher) { instance_double(Cadence::Workflow::Dispatcher) }

  describe '.schedule' do
    it 'appends decision' do
      expect(subject.decisions.length).to eq(0)

      subject.schedule(Cadence::Workflow::Decision::CompleteWorkflow.new)

      expect(subject.decisions.length).to eq(1)
    end

    # These are all "terminal" decisions
    [
      Cadence::Workflow::Decision::FailWorkflow.new(
        reason: 'dummy',
        ),
      Cadence::Workflow::Decision::CompleteWorkflow.new(
        result: 5,
        ),
    ].each do |terminal_command|
      it "fails to validate if #{terminal_command.class} is not the last command scheduled" do
        state_manager = described_class.new(Cadence::Workflow::Dispatcher.new)

        next_command = Cadence::Workflow::Decision::RecordMarker.new(
          name: Cadence::Workflow::StateManager::RELEASE_MARKER,
          details: 'dummy',
          )

        state_manager.schedule(terminal_command)
        expect do
          state_manager.schedule(next_command)
        end.to raise_error(Cadence::WorkflowAlreadyCompletingError)
      end
    end
  end

  describe '.apply' do
    let(:event) { Cadence::Workflow::History::Event.new(raw_event) }
    let(:window) do
      window = Cadence::Workflow::History::Window.new
      window.add(event)
      window
    end

    before do
      allow(window).to receive(:replay?).and_return(true)
    end

    describe 'ActivityTaskScheduled event' do
      let(:input) { ['foo', 'bar', { 'foo' => 'bar' }] }
      let(:raw_event) { Fabricate(:activity_task_scheduled_event_thrift, eventId: 1, input: input) }

      before do
        subject.schedule(decision)
      end

      context 'event matchs previous decision' do
        let(:decision) do
          Cadence::Workflow::Decision::ScheduleActivity.new(
            activity_type: 'TestActivity',
            activity_id: 1,
            input: input
          )
        end

        it 'applies' do
          expect(subject.decisions.length).to eq(1)

          subject.apply(window)

          expect(subject.decisions.length).to eq(0)
        end
      end

      context 'event does not matchs previous decision activity name' do
        let(:decision) do
          Cadence::Workflow::Decision::ScheduleActivity.new(
            activity_type: 'AnotherTestActivity',
            activity_id: 1,
            input: input
          )
        end

        it 'raises NonDeterministicWorkflowError' do
          expect { subject.apply(window) }.to raise_error(Cadence::NonDeterministicWorkflowError)
        end
      end

      context 'event does not matchs previous decision activity id' do
        let(:decision) do
          Cadence::Workflow::Decision::ScheduleActivity.new(
            activity_type: 'TestActivity',
            activity_id: 2,
            input: input
          )
        end

        it 'raises NonDeterministicWorkflowError' do
          expect { subject.apply(window) }.to raise_error(Cadence::NonDeterministicWorkflowError)
        end
      end

      context 'event does not matchs previous decision activity input' do
        let(:decision) do
          Cadence::Workflow::Decision::ScheduleActivity.new(
            activity_type: 'TestActivity',
            activity_id: 1,
            input: ['foo', 'bar', { 'foo' => 'foo' }]
          )
        end

        it 'raises NonDeterministicWorkflowError' do
          expect { subject.apply(window) }.to raise_error(Cadence::NonDeterministicWorkflowError)
        end
      end
    end
  end
end
