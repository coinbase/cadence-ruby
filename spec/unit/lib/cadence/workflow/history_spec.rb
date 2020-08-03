require 'cadence/workflow/history'

describe Cadence::Workflow::History do
  let(:history) { described_class.new(events) }
  describe '.last_completed_decision_task' do
    let(:event_mock_1) do
      double('EventMock', eventId: 1, timestamp: (Time.now - 1000).to_f, eventType: event_type, eventAttributes: '', public_send: '')
    end
    let(:event_mock_2) do
      double('EventMock', eventId: 2, timestamp: Time.now.to_f, eventType: event_type, eventAttributes: '', public_send: '')
    end
  
    context '> 1 completed decision task exists' do
      let(:event_type) { CadenceThrift::EventType::DecisionTaskCompleted }
      let(:events) { [event_mock_1, event_mock_2] }

      it 'returns the last completed decision task' do
        expect(history.last_completed_decision_task.id).to be(2)
      end
    end

    context '0 completed decision task exists' do
      let(:event_type) { CadenceThrift::EventType::DecisionTaskScheduled }
      let(:events) { [event_mock_1] }
      it 'returns nil' do
        expect(history.last_completed_decision_task).to be(nil)
      end
    end
  end

  describe '#next_window' do
  end
end
