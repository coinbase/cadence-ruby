require 'securerandom'
require 'cadence/workflow/history'

module Helpers
  def run_workflow(workflow, *input, **args)
    workflow_id = SecureRandom.uuid
    args[:options] = args.fetch(:options, {}).merge(workflow_id: workflow_id)

    run_id = Cadence.start_workflow(workflow, *input, **args)

    client = Cadence.send(:default_client)
    connection = client.send(:connection)

    result = connection.get_workflow_execution_history(
      domain: Cadence.configuration.domain,
      workflow_id: workflow_id,
      run_id: run_id,
      next_page_token: nil,
      wait_for_new_event: true,
      event_type: :close
    )

    Cadence::Workflow::History.new(result.history.events)
  end
end
