require 'securerandom'

Fabricator(:workflow_metadata, from: :open_struct) do
  name 'TestWorkflow'
  run_id { SecureRandom.uuid }
  attempt 1
  headers { {} }
  timeouts do
    {
      execution: nil,
      task: nil,
      schedule_to_close: nil,
      schedule_to_start: nil,
      start_to_close: nil,
      heartbeat: nil
    }
  end
end
