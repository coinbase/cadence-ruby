class VersionedWorkflow < Cadence::Workflow
  class V1 < Cadence::Workflow
    def execute
      EchoActivity.execute!('version 1')
    end
  end
end
