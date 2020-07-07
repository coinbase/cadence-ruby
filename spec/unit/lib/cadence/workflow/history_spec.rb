# frozen_string_literal: true

require 'cadence/workflow/history'
require 'pry'

describe Cadence::Workflow::History do
  let(:history) { described_class.new(events) }
  let(:event_mock_1) do
    double('EventMock', eventId: 1, timestamp: (Time.now - 1000).to_f, eventType: event_type, eventAttributes: '', public_send: '')
  end
  let(:event_mock_2) do
    double('EventMock', eventId: 2, timestamp: Time.now.to_f, eventType: event_type, eventAttributes: '', public_send: '')
  end

  describe '.last_completed_decision_task' do
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

  describe '.last_failed_decision_task' do
    context '> 1 failed decision task exists' do
      let(:event_type) { CadenceThrift::EventType::DecisionTaskFailed }
      let(:events) { [event_mock_1, event_mock_2] }

      it 'returns the last failed decision task' do
        expect(history.last_failed_decision_task.id).to eq(2)
      end
    end

    context '0 failed decision task exists' do
      let(:event_type) { CadenceThrift::EventType::DecisionTaskTimedOut }
      let(:events) { [event_mock_1] }
      it 'returns nil' do
        expect(history.last_failed_decision_task).to be(nil)
      end
    end
  end

  describe '.last_timed_out_decision_task' do
    context '> 1 timed out decision task exists' do
      let(:event_type) { CadenceThrift::EventType::DecisionTaskTimedOut }
      let(:events) { [event_mock_1, event_mock_2] }

      it 'returns the last timed out decision task' do
        expect(history.last_timed_out_decision_task.id).to eq(2)
      end
    end

    context '0 timed out decision task exists' do
      let(:event_type) { CadenceThrift::EventType::DecisionTaskFailed }
      let(:events) { [event_mock_1] }
      it 'returns nil' do
        expect(history.last_timed_out_decision_task).to be(nil)
      end
    end
  end

  describe '.last_completed_activity_task' do
    context '> 1 completed activity task exists' do
      let(:event_type) { CadenceThrift::EventType::ActivityTaskCompleted }
      let(:events) { [event_mock_1, event_mock_2] }

      it 'returns the last completed activity task' do
        expect(history.last_completed_activity_task.id).to eq(2)
      end
    end

    context '0 completed activity task exists' do
      let(:event_type) { CadenceThrift::EventType::ActivityTaskStarted }
      let(:events) { [event_mock_1] }
      it 'returns nil' do
        expect(history.last_completed_activity_task).to be(nil)
      end
    end
  end

  describe '.last_failed_activity_task' do
    context '> 1 failed activity task exists' do
      let(:event_type) { CadenceThrift::EventType::ActivityTaskFailed }
      let(:events) { [event_mock_1, event_mock_2] }

      it 'returns the last failed activity task' do
        expect(history.last_failed_activity_task.id).to eq(2)
      end
    end

    context '0 failed activity task exists' do
      let(:event_type) { CadenceThrift::EventType::ActivityTaskTimedOut }
      let(:events) { [event_mock_1] }
      it 'returns nil' do
        expect(history.last_failed_activity_task).to be(nil)
      end
    end
  end

  describe '.last_timed_out_activity_task' do
    context '> 1 failed activity task exists' do
      let(:event_type) { CadenceThrift::EventType::ActivityTaskTimedOut }
      let(:events) { [event_mock_1, event_mock_2] }

      it 'returns the last timed out activity task' do
        expect(history.last_timed_out_activity_task.id).to eq(2)
      end
    end

    context '0 failed activity task exists' do
      let(:event_type) { CadenceThrift::EventType::ActivityTaskFailed }
      let(:events) { [event_mock_1] }
      it 'returns nil' do
        expect(history.last_timed_out_activity_task).to be(nil)
      end
    end
  end

  describe '#next_window' do
  end
end
