require 'securerandom'

Fabricator(:workflow_metadata, from: :open_struct) do
  name 'TestWorkflow'
  run_id { SecureRandom.uuid }
  attempt 1
  headers { {} }
  timeouts do
    {
      execution: 25,
      task: 15
    }
  end
end
