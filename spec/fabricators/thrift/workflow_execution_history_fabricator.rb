require 'gen/thrift/cadence_types'

Fabricator(
  :worklfow_execution_history_thrift,
  from: CadenceThrift::GetWorkflowExecutionHistoryResponse
) do
  history { Fabricate(:history_thrift) }
  nextPageToken nil
end
