require 'cadence/workflow/serializer/base'

module Cadence
  class Workflow
    module Serializer
      class QueryFailure < Base
        def to_proto
          CadenceThrift::WorkflowQueryResult.new(
            result_type: CadenceThrift::QueryResultType::FAILED,
            error_message: object.error.message
          )
        end
      end
    end
  end
end
