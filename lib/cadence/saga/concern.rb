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

        if compensate?(error, **configuration)
          logger.error('Saga compensating')
          saga.compensate
          Result.new(false, error)
        else
          logger.error('Saga not compensating')
          raise error
        end
      end

      def compensate?(error, compensate_on: [], do_not_compensate_on: [])
        error_class = error.class
        if compensate_on.any?
          compensate_on.include?(error_class)
        else
          !do_not_compensate_on.include?(error_class)
        end
      end
    end
  end
end
