require 'workflows/async_timer_workflow'
require 'securerandom'

describe AsyncTimerWorkflow do
  let(:workflow_id) { SecureRandom.uuid }

  around do |example|
    Cadence::Testing.local! { example.run }
  end

  it 'succeeds' do
    run_id = Cadence.start_workflow(described_class, options: { workflow_id: workflow_id })
    Cadence.fire_timer(workflow_id, run_id, 1)

    info = Cadence.fetch_workflow_execution_info('ruby-samples', workflow_id, run_id)

    expect(info).to be_completed
  end

  it 'executes HelloWorldActivity' do
    expect_any_instance_of(HelloWorldActivity)
      .to receive(:execute)
      .with('timer')
      .and_call_original

    run_id = Cadence.start_workflow(described_class, options: { workflow_id: workflow_id })
    Cadence.fire_timer(workflow_id, run_id, 1)
  end
end
