require 'cadence/saga/saga'
require 'cadence/saga/result'

module Cadence
  module Saga
    module Concern
      def run_saga(configuration = {}, &block)
        saga = Cadence::Saga::Saga.new(workflow)

        block.call(saga)

        Result.new(true)
      rescue StandardError => error # TODO: is there a need for a specialized error here?
        logger.error("Saga execution aborted: #{error.inspect}")
        logger.debug(error.backtrace.join("\n"))

        if compensable?(error, configuration)
          logger.error('Saga compensating')
          saga.compensate
          Result.new(false, error)
        else
          logger.error('Saga not compensating')
          raise error
        end
      end

      def compensable?(error, compensable_errors: nil, non_compensable_errors: nil)
        error_class = error.class
        (compensable_errors.nil? && non_compensable_errors.nil?) ||
          (compensable_errors&.include?(error_class) ||
            non_compensable_errors && !non_compensable_errors.include?(error_class))
      end
    end
  end
end
