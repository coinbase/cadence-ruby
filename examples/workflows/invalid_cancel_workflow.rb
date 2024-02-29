require 'activities/hello_world_activity'

# If you run this, you'll get a WorkflowAlreadyCompletingError because after the
# cancel, we try to do something else.
class InvalidCancelWorkflow < Cadence::Workflow
  timeouts execution: 20

  def execute
    future = HelloWorldActivity.execute('Alice')
    workflow.sleep(1)
    workflow.cancel
    # Doing anything after cancel (or any workflow completion) is illegal
    future.done do
      HelloWorldActivity.execute('Bob')
    end
  end
end