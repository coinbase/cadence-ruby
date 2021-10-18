require 'gen/thrift/cadence_types'
require 'cadence/utils'

Fabricator(:workflow_execution_info_thrift, from: CadenceThrift::WorkflowExecutionInfo) do
  transient :workflow_id, :workflow

  execution { |attrs| Fabricate(:workflow_execution_thrift, workflowId: attrs[:workflow_id]) }
  type { |attrs| Fabricate(:workflow_type_thrift, name: attrs[:workflow]) }
  startTime { Cadence::Utils.time_to_nanos(Time.now) }
  closeTime { Cadence::Utils.time_to_nanos(Time.now) }
  closeStatus { CadenceThrift::WorkflowExecutionCloseStatus::COMPLETED }
  historyLength { rand(100) }
end
