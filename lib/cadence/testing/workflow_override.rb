require 'securerandom'
require 'cadence/testing/local_workflow_context'
require 'cadence/testing/workflow_execution'
require 'cadence/metadata/workflow'

module Cadence
  module Testing
    module WorkflowOverride
      def disabled_releases
        @disabled_releases ||= Set.new
      end

      def allow_all_releases
        disabled_releases.clear
      end

      def allow_release(release_name)
        disabled_releases.delete(release_name.to_s)
      end

      def disable_release(release_name)
        disabled_releases << release_name.to_s
      end

      def execute_locally(*input)
        workflow_id = SecureRandom.uuid
        run_id = SecureRandom.uuid
        execution = WorkflowExecution.new
        metadata = Cadence::Metadata::Workflow.new(
          name: workflow_id,
          run_id: run_id,
          attempt: 1,
          timeouts: {}
        )
        context = Cadence::Testing::LocalWorkflowContext.new(
          execution, workflow_id, run_id, disabled_releases, metadata
        )

        execute_in_context(context, input)
      end
    end
  end
end
