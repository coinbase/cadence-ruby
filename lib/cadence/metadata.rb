require 'cadence/errors'
require 'cadence/metadata/activity'
require 'cadence/metadata/decision'
require 'cadence/metadata/workflow'

module Cadence
  module Metadata
    ACTIVITY_TYPE = :activity
    DECISION_TYPE = :decision

    class << self
      def generate(type, data, domain)
        case type
        when ACTIVITY_TYPE
          activity_metadata_from(data, domain)
        when DECISION_TYPE
          decision_metadata_from(data, domain)
        else
          raise InternalError, 'Unsupported metadata type'
        end
      end

      private

      def activity_metadata_from(task, domain)
        Metadata::Activity.new(
          domain: domain,
          id: task.activityId,
          name: task.activityType.name,
          task_token: task.taskToken,
          attempt: task.attempt,
          workflow_run_id: task.workflowExecution.runId,
          workflow_id: task.workflowExecution.workflowId,
          workflow_name: task.workflowType.name,
          headers: task.header&.fields || {},
          timeouts: {
            start_to_close: task.startToCloseTimeoutSeconds,
            schedule_to_close: task.scheduleToCloseTimeoutSeconds,
            heartbeat: task.heartbeatTimeoutSeconds
          }
        )
      end

      def decision_metadata_from(task, domain)
        Metadata::Decision.new(
          domain: domain,
          id: task.startedEventId,
          task_token: task.taskToken,
          attempt: task.attempt,
          workflow_run_id: task.workflowExecution.runId,
          workflow_id: task.workflowExecution.workflowId,
          workflow_name: task.workflowType.name
        )
      end
    end
  end
end
