require 'workflows/cancelling_timer_workflow'
require 'securerandom'

describe CancellingTimerWorkflow do
  let(:workflow_id) { SecureRandom.uuid }
  let(:activity_timeout) { 0.01 }

  around do |example|
    Cadence::Testing.local! { example.run }
  end

  it 'succeeds' do
    run_id = Cadence.start_workflow(
      described_class, activity_timeout, 10, options: { workflow_id: workflow_id }
    )

    info = Cadence.fetch_workflow_execution_info('ruby-samples', workflow_id, run_id)

    expect(info.status).to eq(Cadence::Workflow::ExecutionInfo::COMPLETED_STATUS)
  end
end
