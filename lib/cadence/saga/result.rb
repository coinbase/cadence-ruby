module Cadence
  module Saga
    class Result
      STATUSES = [
        COMPLETED = :completed,
        COMPENSATED = :compensated,
        FAILED = :failed
      ]

      attr_reader :rollback_reason

      def initialize(status, rollback_reason = nil)
        @status = status
        @rollback_reason = rollback_reason

        freeze
      end

      def completed?
        @status == COMPLETED
      end

      def compensated?
        @status == COMPENSATED
      end

      def failed?
        @status == FAILED
      end
    end
  end
end
