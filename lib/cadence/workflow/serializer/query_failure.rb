require 'cadence/workflow/serializer/base'

module Cadence
  class Workflow
    module Serializer
      class QueryFailure < Base
        def to_thrift
          CadenceThrift::WorkflowQueryResult.new(
            resultType: CadenceThrift::QueryResultType::FAILED,
            errorReason: object.error.message
          )
        end
      end
    end
  end
end
