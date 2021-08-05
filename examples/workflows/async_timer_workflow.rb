require 'activities/async_activity'

class AsyncTimerWorkflow < Cadence::Workflow
  def execute
    timer = workflow.start_timer(30)
    timer.done { logger.info('Timer fired!') }

    workflow.wait_for(timer)
  end
end
