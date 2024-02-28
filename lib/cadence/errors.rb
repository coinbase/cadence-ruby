module Cadence
  # Superclass for all Cadence errors
  class Error < StandardError; end

  # Superclass for errors specific to Cadence worker itself
  class InternalError < Error; end

  # Indicates a non-deterministic workflow execution, might be due to
  # a non-deterministic workflow implementation or the gem's bug
  class NonDeterministicWorkflowError < InternalError; end

  # Superclass for misconfiguration/misuse on the client (user) side
  class ClientError < Error; end

  # Represents any timeout
  class TimeoutError < ClientError; end

  # A superclass for activity exceptions raised explicitly
  # with the itent to propagate to a workflow
  class ActivityException < ClientError; end

  # Once the workflow succeeds, fails, or continues as new, you can't issue any other commands such as
  # scheduling an activity.  This error is thrown if you try, before we report completion back to the server.
  # This could happen due to activity futures that aren't awaited before the workflow closes,
  # calling workflow.continue_as_new, workflow.complete, or workflow.fail in the middle of your workflow code,
  # or an internal framework bug.
  class WorkflowAlreadyCompletingError < InternalError; end
end
