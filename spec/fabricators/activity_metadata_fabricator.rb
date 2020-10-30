require 'securerandom'

Fabricator(:activity_metadata, from: :open_struct) do
  domain 'test-domain'
  id { sequence(:activity_id) }
  name 'TestActivity'
  task_token { SecureRandom.uuid }
  attempt 1
  workflow_run_id { SecureRandom.uuid }
  workflow_id { SecureRandom.uuid }
  workflow_name 'TestWorkflow'
  timeouts do
    {
      execution: nil,
      task: nil,
      schedule_to_close: 15,
      schedule_to_start: nil,
      start_to_close: 25,
      heartbeat: 5
    }
  end
  headers { {} }
end
