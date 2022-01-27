class VersionedWorkflow < Cadence::Workflow
  class V2 < Cadence::Workflow
    headers 'MyNewHeader' => 'MyNewValue'

    def execute
      EchoActivity.execute!('version 2')
    end
  end
end
