require 'cadence/metadata/base'

module Cadence
  module Metadata
    class Activity < Base
      attr_reader :domain, :id, :name, :task_token, :attempt, :workflow_run_id, :workflow_id, :workflow_name, :headers, :timeouts

      def initialize(domain:, id:, name:, task_token:, attempt:, workflow_run_id:, workflow_id:, workflow_name:, timeouts:, headers: {})
        @domain = domain
        @id = id
        @name = name
        @task_token = task_token
        @attempt = attempt
        @workflow_run_id = workflow_run_id
        @workflow_id = workflow_id
        @workflow_name = workflow_name
        @timeouts = timeouts
        @headers = headers

        freeze
      end

      def activity?
        true
      end

      def to_h
        {
          domain: domain,
          workflow_id: workflow_id,
          workflow_name: workflow_name,
          workflow_run_id: workflow_run_id,
          activity_id: id,
          activity_name: name,
          attempt: attempt
        }
      end
    end
  end
end
