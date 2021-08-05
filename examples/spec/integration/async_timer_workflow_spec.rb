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

    expect(info.status).to eq(Cadence::Workflow::ExecutionInfo::COMPLETED_STATUS)
  end
end
