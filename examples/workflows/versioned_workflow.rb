require 'cadence/concerns/versioned'
require_relative './versioned_workflow/v1'
require_relative './versioned_workflow/v2'

class VersionedWorkflow < Cadence::Workflow
  include Cadence::Concerns::Versioned

  headers 'MyHeader' => 'MyValue'

  version 1, V1
  version 2, V2

  def execute
    EchoActivity.execute!('default version')
  end
end
