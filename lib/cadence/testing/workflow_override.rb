require 'securerandom'
require 'cadence/testing/local_workflow_context'
require 'cadence/testing/workflow_execution'

module Cadence
  module Testing
    module WorkflowOverride
      def disallowed_breaking_changes
        @disallowed_breaking_changes ||= Set.new
      end

      def allow_all_breaking_changes
        disallowed_breaking_changes.clear
      end

      def allow_breaking_change(change_name)
        disallowed_breaking_changes.delete(change_name.to_s)
      end

      def disallow_breaking_change(change_name)
        disallowed_breaking_changes << change_name.to_s
      end

      def execute_locally(*input)
        workflow_id = SecureRandom.uuid
        run_id = SecureRandom.uuid
        execution = WorkflowExecution.new
        context = Cadence::Testing::LocalWorkflowContext.new(
          execution, workflow_id, run_id, disallowed_breaking_changes
        )

        execute_in_context(context, input)
      end
    end
  end
end
