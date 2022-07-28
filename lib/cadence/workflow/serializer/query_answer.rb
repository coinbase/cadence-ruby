require 'cadence/workflow/serializer/base'

module Cadence
  class Workflow
    module Serializer
      class QueryAnswer < Base

        def to_proto
          CadenceThrift::WorkflowQueryResult.new(
            result_type: CadenceThrift::QueryResultType::ANSWERED,
            answer: JSON.serialize(object.result)
          )
        end
      end
    end
  end
end