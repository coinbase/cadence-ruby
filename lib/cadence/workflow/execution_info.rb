require 'cadence/utils'

module Cadence
  class Workflow
    class ExecutionInfo < Struct.new(:workflow, :workflow_id, :run_id, :start_time, :close_time, :status, :history_length, keyword_init: true)
      OPEN_STATUS = :OPEN
      COMPLETED_STATUS = :COMPLETED
      FAILED_STATUS = :FAILED
      CANCELED_STATUS = :CANCELED
      TERMINATED_STATUS = :TERMINATED
      CONTINUED_AS_NEW_STATUS = :CONTINUED_AS_NEW
      TIMED_OUT_STATUS = :TIMED_OUT
      CLOSED_STATUS = :CLOSED # agreggation of all closed statuses

      CLOSED_STATUSES = [
        COMPLETED_STATUS,
        FAILED_STATUS,
        CANCELED_STATUS,
        TERMINATED_STATUS,
        CONTINUED_AS_NEW_STATUS,
        TIMED_OUT_STATUS,
      ].freeze

      VALID_STATUSES = [
        OPEN_STATUS,
        COMPLETED_STATUS,
        FAILED_STATUS,
        CANCELED_STATUS,
        TERMINATED_STATUS,
        CONTINUED_AS_NEW_STATUS,
        TIMED_OUT_STATUS
      ].freeze

      def self.generate_from(response)
        status = ::CadenceThrift::WorkflowExecutionCloseStatus::VALUE_MAP[response.closeStatus]

        new(
          workflow: response.type.name,
          workflow_id: response.execution.workflowId,
          run_id: response.execution.runId,
          start_time: Utils.time_from_nanos(response.startTime),
          close_time: Utils.time_from_nanos(response.closeTime),
          status: status&.to_sym || OPEN_STATUS,
          history_length: response.historyLength,
        ).freeze
      end

      VALID_STATUSES.each do |status|
        define_method("#{status.downcase}?") do
          self.status == status
        end
      end

      # Backwards compatibility
      def running?
        self.status == OPEN_STATUS
      end

      def closed?
        CLOSED_STATUSES.include?(status)
      end
    end
  end
end
