Fabricator(:api_workflow_query, from: CadenceThrift::WorkflowQuery) do
  query_type { 'state' }
  # might need to change the line below
  query_args { Cadence::JSON.serialize(['']) }
end

