require 'cadence/workflow/serializer/base'

module Cadence
  class Workflow
    module Serializer
      class QueryAnswer < Base
        def to_thrift
          CadenceThrift::WorkflowQueryResult.new(
            resultType: CadenceThrift::QueryResultType::ANSWERED,
            answer: JSON.serialize(object.result)
          )
        end
      end
    end
  end
end