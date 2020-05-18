require 'activities/echo_activity'

class ReleaseWorkflow < Cadence::Workflow
  def execute
    EchoActivity.execute!('Original activity 1')

    workflow.after_release(:fix_1) do
      EchoActivity.execute!('Added activity 1')
    end

    workflow.sleep(5)

    if workflow.release?(:fix_1)
      EchoActivity.execute!('Added activity 2')
    else
      EchoActivity.execute!('Original removed activity')
    end

    workflow.sleep(5)

    workflow.after_release(:fix_2) do
      EchoActivity.execute!('Added activity 3')
    end

    return
  end
end
