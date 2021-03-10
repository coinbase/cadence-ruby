require 'cadence/connection'
require 'cadence/thread_pool'
require 'cadence/middleware/chain'
require 'cadence/workflow/decision_task_processor'

module Cadence
  class Workflow
    class Poller
      DEFAULT_OPTIONS = {
        thread_pool_size: 1
      }.freeze

      def initialize(domain, task_list, workflow_lookup, config, middleware = [], options = {})
        @domain = domain
        @task_list = task_list
        @workflow_lookup = workflow_lookup
        @config = config
        @middleware = middleware
        @options = DEFAULT_OPTIONS.merge(options)
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
        thread_pool.shutdown
      end

      private

      attr_reader :domain, :task_list, :connection, :workflow_lookup, :config, :middleware, :options

      def connection
        @connection ||= Cadence::Connection.generate(config.for_connection, options)
      end

      def shutting_down?
        @shutting_down
      end

      def poll_loop
        last_poll_time = Time.now
        metrics_tags = { domain: domain, task_list: task_list }.freeze

        loop do
          thread_pool.wait_for_available_threads

          return if shutting_down?

          time_diff_ms = ((Time.now - last_poll_time) * 1000).round
          Cadence.metrics.timing('workflow_poller.time_since_last_poll', time_diff_ms, metrics_tags)
          Cadence.logger.debug("Polling for decision tasks (#{domain} / #{task_list})")

          task = poll_for_task
          last_poll_time = Time.now
          next unless task&.workflowType

          thread_pool.schedule { process(task) }
        end
      end

      def poll_for_task
        connection.poll_for_decision_task(domain: domain, task_list: task_list)
      rescue StandardError => error
        Cadence.logger.error("Unable to poll for a decision task: #{error.inspect}")
        nil
      end

      def process(task)
        middleware_chain = Middleware::Chain.new(middleware)

        DecisionTaskProcessor.new(task, domain, workflow_lookup, middleware_chain, config).process
      end

      def thread_pool
        @thread_pool ||= ThreadPool.new(options[:thread_pool_size])
      end
    end
  end
end
