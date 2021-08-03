require 'cadence/workflow/history/event_target'
require 'cadence/workflow/history/event'

describe Cadence::Workflow::History::EventTarget do
  describe '.from_event' do
    subject { described_class.from_event(event) }
    let(:event) { Cadence::Workflow::History::Event.new(raw_event) }

    context 'when event is TimerStarted' do
      let(:raw_event) { Fabricate(:timer_started_event_thrift) }

      it 'sets type to timer' do
        expect(subject.type).to eq(described_class::TIMER_TYPE)
      end
    end

    context 'when event is TimerCanceled' do
      let(:raw_event) { Fabricate(:timer_canceled_event_thrift) }

      it 'sets type to cancel_timer_request' do
        expect(subject.type).to eq(described_class::CANCEL_TIMER_REQUEST_TYPE)
      end
    end
  end
end
