require 'workflows/async_activity_workflow'
require 'securerandom'

describe AsyncActivityWorkflow do
  let(:workflow_id) { SecureRandom.uuid }

  around do |example|
    Cadence::Testing.local! { example.run }
  ensure
    $async_token = nil
  end

  context 'when activity completes' do
    it 'succeeds' do
      run_id = Cadence.start_workflow(described_class, options: { workflow_id: workflow_id })
      Cadence.complete_activity($async_token)

      info = Cadence.fetch_workflow_execution_info('ruby-samples', workflow_id, run_id)

      expect(info.status).to eq(Cadence::Workflow::ExecutionInfo::COMPLETED_STATUS)
    end
  end

  context 'when activity fails' do
    it 'fails' do
      run_id = Cadence.start_workflow(described_class, options: { workflow_id: workflow_id })
      Cadence.fail_activity($async_token, StandardError.new('test failure'))

      info = Cadence.fetch_workflow_execution_info('ruby-samples', workflow_id, run_id)

      expect(info.status).to eq(Cadence::Workflow::ExecutionInfo::FAILED_STATUS)
    end
  end
end
