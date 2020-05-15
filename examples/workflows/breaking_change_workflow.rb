require 'activities/echo_activity'

class BreakingChangeWorkflow < Cadence::Workflow
  def execute
    EchoActivity.execute!('Original activity 1')

    workflow.breaking_change(:fix_1) do
      EchoActivity.execute!('Added activity 1')
    end

    workflow.sleep(5)

    if workflow.breaking_change_allowed?(:fix_1)
      EchoActivity.execute!('Added activity 2')
    else
      EchoActivity.execute!('Original removed activity')
    end

    workflow.sleep(5)

    workflow.breaking_change(:fix_2) do
      EchoActivity.execute!('Added activity 3')
    end

    return
  end
end
