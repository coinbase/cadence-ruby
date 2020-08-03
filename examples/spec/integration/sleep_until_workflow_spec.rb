require 'workflows/sleep_until_workflow'

describe SleepUntilWorkflow do
  subject { described_class }
  let(:start_time) { Time.now }
  let(:end_time) { Time.now + 1.minute}
  let(:delay_time) { (end_time-start_time).to_i }

  before do
    allow(HelloWorldActivity).to receive(:execute!).and_call_original
    allow(::Kernel).to receive(:sleep)
    Timecop.freeze(start_time)
  end

  it 'executes HelloWorldActivity after sleeping until the given end_time' do
    subject.execute_locally(end_time)
    expect(::Kernel).to have_received(:sleep).with(delay_time)
    Timecop.travel(1.minute)

    expect(HelloWorldActivity).to have_received(:execute!).with('yay').ordered
  end

  it 'returns nil' do
    expect(subject.execute_locally).to eq(nil)
  end
end
