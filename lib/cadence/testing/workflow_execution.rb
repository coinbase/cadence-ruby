require 'cadence/testing/future_registry'
require 'cadence/workflow/status'

module Cadence
  module Testing
    class WorkflowExecution
      attr_reader :status

      def initialize
        @status = Workflow::Status::OPEN
        @futures = FutureRegistry.new
      end

      def run(&block)
        @fiber = Fiber.new(&block)
        resume
      end

      def resume
        fiber.resume
        @status = Workflow::Status::COMPLETED unless fiber.alive?
      rescue StandardError
        @status = Workflow::Status::FAILED
      end

      def register_future(id, future)
        futures.register(id, future)
      end

      def complete_future(id, result = nil)
        futures.complete(id, result)
        resume
      end

      def fail_future(id, error)
        futures.fail(id, error)
        resume
      end

      private

      attr_reader :fiber, :futures
    end
  end
end
