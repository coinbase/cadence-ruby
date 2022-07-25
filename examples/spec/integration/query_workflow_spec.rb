require 'examples/workflows/query_workflow'
require 'cadence/errors'


describe QueryWorkflow, :integration do
  subject { described_class }

  it 'returns the correct result for the queries' do
    workflow_id, run_id = run_workflow(described_class)

    # Query with nil workflow class
    expect(Cadence.query_workflow(nil, 'state', workflow_id, run_id))
      .to eq 'started'

    # Query with arbitrary args
    expect(Cadence.query_workflow(described_class, 'state', workflow_id, run_id,
                                   'upcase', 'ignored', 'reverse'))
      .to eq 'DETRATS'

    # Query with no args
    expect(Cadence.query_workflow(described_class, 'signal_count', workflow_id, run_id))
      .to eq 0

    # Query with unregistered handler
    expect { Cadence.query_workflow(described_class, 'unknown_query', workflow_id, run_id) }
      .to raise_error(Cadence::QueryFailed, 'Workflow did not register a handler for unknown_query')

    Cadence.signal_workflow(described_class, 'make_progress', workflow_id, run_id)

    # Query for updated signal_count with an unsatisfied reject condition
    expect(Cadence.query_workflow(described_class, 'signal_count', workflow_id, run_id, query_reject_condition: :not_open))
      .to eq 1

    Cadence.signal_workflow(described_class, 'finish', workflow_id, run_id)
    wait_for_workflow_completion(workflow_id, run_id)

    # Repeating original query scenarios above, expecting updated state and signal results
    expect(Cadence.query_workflow(nil, 'state', workflow_id, run_id))
      .to eq 'finished'

    expect(Cadence.query_workflow(described_class, 'state', workflow_id, run_id,
                                   'upcase', 'ignored', 'reverse'))
      .to eq 'DEHSINIF'

    expect(Cadence.query_workflow(described_class, 'signal_count', workflow_id, run_id))
      .to eq 2

    expect { Cadence.query_workflow(described_class, 'unknown_query', workflow_id, run_id) }
      .to raise_error(Cadence::QueryFailed, 'Workflow did not register a handler for unknown_query')

    # Now that the workflow is completed, test a query with a reject condition satisfied
    expect { Cadence.query_workflow(described_class, 'state', workflow_id, run_id, query_reject_condition: :not_open) }
      .to raise_error(Cadence::QueryFailed, 'Query rejected: status WORKFLOW_EXECUTION_STATUS_COMPLETED')
  end
end