require 'cadence/client'
require 'cadence/middleware/chain'
require 'cadence/workflow/decision_task_processor'

module Cadence
  class Workflow
    class Poller
      def initialize(domain, task_list, workflow_lookup, middleware = [], options = {})
        @domain = domain
        @task_list = task_list
        @workflow_lookup = workflow_lookup
        @middleware = middleware
        @options = options
        @shutting_down = false
      end

      def start
        @shutting_down = false
        @thread = Thread.new(&method(:poll_loop))
      end

      def stop
        @shutting_down = true
        Cadence.logger.info('Shutting down a workflow poller')
      end

      def wait
        @thread.join
      end

      private

      attr_reader :domain, :task_list, :client, :workflow_lookup, :middleware, :options

      def client
        @client ||= Cadence::Client.generate(options)
      end

      def middleware_chain
        @middleware_chain ||= Middleware::Chain.new(middleware)
      end

      def shutting_down?
        @shutting_down
      end

      def poll_loop
        last_poll_time = Time.now
        metrics_tags = { domain: domain, task_list: task_list }.freeze

        while !shutting_down? do
          time_diff_ms = ((Time.now - last_poll_time) * 1000).round
          Cadence.metrics.timing('workflow_poller.time_since_last_poll', time_diff_ms, metrics_tags)
          Cadence.logger.debug("Polling for decision tasks (#{domain} / #{task_list})")

          task = poll_for_task
          last_poll_time = Time.now
          process(task) if task&.workflowType
        end
      end

      def poll_for_task
        client.poll_for_decision_task(domain: domain, task_list: task_list)
      rescue StandardError => error
        Cadence.logger.error("Unable to poll for a decision task: #{error.inspect}")
        nil
      end

      def process(task)
        DecisionTaskProcessor.new(task, domain, workflow_lookup, client, middleware_chain).process
      end
    end
  end
end
