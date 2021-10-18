require 'cadence/utils'
require 'cadence/workflow/status'

module Cadence
  class Workflow
    class ExecutionInfo < Struct.new(:workflow, :workflow_id, :run_id, :start_time, :close_time, :status, :history_length, keyword_init: true)
      STATUSES = [
        Cadence::Workflow::Status::OPEN,
        Cadence::Workflow::Status::COMPLETED,
        Cadence::Workflow::Status::FAILED,
        Cadence::Workflow::Status::CANCELED,
        Cadence::Workflow::Status::TERMINATED,
        Cadence::Workflow::Status::CONTINUED_AS_NEW,
        Cadence::Workflow::Status::TIMED_OUT
      ].freeze

      def self.generate_from(response)
        status = ::CadenceThrift::WorkflowExecutionCloseStatus::VALUE_MAP[response.closeStatus]

        new(
          workflow: response.type.name,
          workflow_id: response.execution.workflowId,
          run_id: response.execution.runId,
          start_time: Utils.time_from_nanos(response.startTime),
          close_time: Utils.time_from_nanos(response.closeTime),
          status: status&.to_sym || Cadence::Workflow::Status::OPEN,
          history_length: response.historyLength,
        ).freeze
      end

      STATUSES.each do |status|
        define_method("#{status.downcase}?") do
          self.status == status
        end
      end

      # Backwards compatibility
      def running?
        self.status == Cadence::Workflow::Status::OPEN
      end

      def closed?
        !running?
      end
    end
  end
end
