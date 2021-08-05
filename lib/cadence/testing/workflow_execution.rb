require 'cadence/testing/future_registry'

module Cadence
  module Testing
    class WorkflowExecution
      attr_reader :status

      def initialize
        @status = Workflow::ExecutionInfo::RUNNING_STATUS
        @futures = FutureRegistry.new
      end

      def run(&block)
        @fiber = Fiber.new(&block)
        resume
      end

      def resume
        fiber.resume
        @status = Workflow::ExecutionInfo::COMPLETED_STATUS unless fiber.alive?
      rescue StandardError
        @status = Workflow::ExecutionInfo::FAILED_STATUS
      end

      def register_future(id, future)
        futures.register(id, future)
      end

      def complete_activity(id, result)
        futures.complete(id, result)
        resume
      end

      def fail_activity(id, error)
        futures.fail(id, error)
        resume
      end

      private

      attr_reader :fiber, :futures
    end
  end
end
