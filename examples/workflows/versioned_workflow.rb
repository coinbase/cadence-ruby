require 'cadence/concerns/versioned'
require_relative './versioned_workflow_v1'
require_relative './versioned_workflow_v2'

class VersionedWorkflow < Cadence::Workflow
  include Cadence::Concerns::Versioned

  headers 'MyHeader' => 'MyValue'

  version 1, VersionedWorkflowV1
  version 2, VersionedWorkflowV2

  def execute
    EchoActivity.execute!('default version')
  end
end
