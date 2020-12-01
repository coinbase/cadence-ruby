require 'cadence/saga/saga'
require 'cadence/saga/result'

module Cadence
  module Saga
    module Concern
      def run_saga(&block)
        saga = Cadence::Saga::Saga.new(workflow)

        block.call(saga)

        Result.new(Result::COMPLETED)
      rescue StandardError => error # TODO: is there a need for a specialized error here?
        logger.error("Saga execution aborted: #{error.inspect}")
        logger.debug(error.backtrace.join("\n"))

        if compensable?(error)
          saga.compensate
          Result.new(Result::COMPENSATED, error)
        else
          Result.new(Result::FAILED, error)
        end
      end

      def compensable?(error)
        !self.class.respond_to?(:compensable?) || self.class.compensable?(error)
      end
    end
  end
end
