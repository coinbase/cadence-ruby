require 'securerandom'
require 'workflows/parent_workflow'

describe ParentWorkflow do
  subject { described_class }

  before do
    allow(HelloWorldWorkflow).to receive(:execute!).and_call_original
    allow(HelloWorldActivity).to receive(:execute!).and_call_original
  end

  it 'executes HelloWorldWorkflow' do
    subject.execute_locally

    expect(HelloWorldWorkflow).to have_received(:execute!)
  end

  it 'executes HelloWorldActivity twice' do
    subject.execute_locally

    expect(HelloWorldActivity).to have_received(:execute!).with('Alice').ordered
    expect(HelloWorldActivity).to have_received(:execute!).with('Bob').ordered
  end

  it 'returns nil' do
    expect(subject.execute_locally).to eq(nil)
  end

  context 'integration' do
    let(:workflow_id) { SecureRandom.uuid }

    around do |example|
      Cadence::Testing.local! do
        example.run
      end
    end

    it 'works' do
      run_id = Cadence.start_workflow(described_class, options: { workflow_id: workflow_id })
      info = Cadence.fetch_workflow_execution_info('test', workflow_id, run_id)

      expect(HelloWorldActivity).to have_received(:execute!).with('Alice').ordered
      expect(HelloWorldActivity).to have_received(:execute!).with('Bob').ordered

      expect(info).to be_completed
    end
  end
end
