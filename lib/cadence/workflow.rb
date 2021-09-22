require 'cadence/concerns/executable'
require 'cadence/workflow/convenience_methods'
require 'cadence/thread_local_context'
require 'cadence/error_handler'

module Cadence
  class Workflow
    extend Concerns::Executable
    extend ConvenienceMethods

    def self.execute_in_context(context, input)
      previous_context = Cadence::ThreadLocalContext.get
      Cadence::ThreadLocalContext.set(context)

      workflow = new(context)
      result = workflow.execute(*input)

      context.complete(result)
    rescue StandardError, ScriptError => error
      Cadence.logger.error("Workflow execution failed with: #{error.inspect}")
      Cadence.logger.debug(error.backtrace.join("\n"))

      Cadence::ErrorHandler.handle(error, metadata: context.metadata)

      context.fail(error.class.name, error.message)
    ensure
      Cadence::ThreadLocalContext.set(previous_context) if previous_context
    end

    def initialize(context)
      @context = context
    end

    def execute
      raise NotImplementedError, '#execute method must be implemented by a subclass'
    end

    private

    def workflow
      @context
    end

    def logger
      workflow.logger
    end
  end
end
