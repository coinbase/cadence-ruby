require 'cadence/connection'
require 'cadence/thread_pool'
require 'cadence/middleware/chain'
require 'cadence/activity/task_processor'

module Cadence
  class Activity
    class Poller
      DEFAULT_OPTIONS = {
        thread_pool_size: 20
      }.freeze

      def initialize(domain, task_list, activity_lookup, config, middleware = [], options = {})
        @domain = domain
        @task_list = task_list
        @activity_lookup = activity_lookup
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
        Cadence.logger.info('Shutting down activity poller')
      end

      def wait
        thread.join
        thread_pool.shutdown
      end

      private

      attr_reader :domain, :task_list, :activity_lookup, :config, :middleware, :options, :thread

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
          Cadence.metrics.timing('activity_poller.time_since_last_poll', time_diff_ms, metrics_tags)
          Cadence.logger.debug("Polling for activity tasks (#{domain} / #{task_list})")

          task = poll_for_task
          last_poll_time = Time.now
          next unless task&.activityId

          thread_pool.schedule { process(task) }
        end
      end

      def poll_for_task
        connection.poll_for_activity_task(domain: domain, task_list: task_list)
      rescue StandardError => error
        Cadence.logger.error("Unable to poll for an activity task: #{error.inspect}")
        nil
      end

      def process(task)
        connection = Cadence::Connection.generate(config.for_connection)
        middleware_chain = Middleware::Chain.new(middleware)

        TaskProcessor.new(task, domain, activity_lookup, connection, middleware_chain).process
      end

      def thread_pool
        @thread_pool ||= ThreadPool.new(options[:thread_pool_size])
      end
    end
  end
end
