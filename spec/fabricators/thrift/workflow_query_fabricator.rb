Fabricator(:api_workflow_query, from: CadenceThrift::WorkflowQuery) do
  queryType { 'state' }
  # might need to change the line below
  queryArgs { Cadence::JSON.serialize(['']) }
end

