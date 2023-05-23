require 'securerandom'

Fabricator(:workflow_metadata, from: :open_struct) do
  domain 'test-domain'
  id { SecureRandom.uuid }
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

Fabricator(:workflow_metadata_with_parent, from: :open_struct) do
  domain 'test-domain'
  id { SecureRandom.uuid }
  name 'TestWorkflow'
  run_id { SecureRandom.uuid }
  parent_workflow_id { SecureRandom.uuid }
  parent_workflow_run_id { SecureRandom.uuid }
  attempt 1
  headers { {} }
  timeouts do
    {
      execution: 25,
      task: 15
    }
  end
end
