require 'activities/hello_world_activity'

class SleepUntilWorkflow < Cadence::Workflow
  def execute(end_time)
    workflow.sleep_until(end_time)

    HelloWorldActivity.execute!('yay')

    return
  end
end
