require 'cadence/metadata'
require 'cadence/activity/context'
require 'cadence/json'
require 'cadence/connection'
require 'cadence/error_handler'
require 'cadence/concerns/input_deserializer'

module Cadence
  class Activity
    class TaskProcessor
      include Cadence::Concerns::InputDeserializer

      def initialize(task, domain, activity_lookup, middleware_chain, config)
        @task = task
        @domain = domain
        @metadata = Metadata.generate(Metadata::ACTIVITY_TYPE, task, domain)
        @task_token = task.taskToken
        @workflow_name = task.workflowType.name
        @workflow_id = task.workflowExecution.workflowId
        @activity_name = task.activityType.name
        @activity_id = task.activityId
        @activity_class = activity_lookup.find(activity_name)
        @middleware_chain = middleware_chain
        @config = config
      end

      def process
        start_time = Time.now

        Cadence.logger.info("Processing activity task for #{activity_log_name}")
        Cadence.metrics.timing('activity_task.queue_time', queue_time_ms, activity: activity_name)

        if !activity_class
          respond_failed('ActivityNotRegistered', 'Activity is not registered with this worker')
          return
        end

        context = Activity::Context.new(connection, metadata)

        result = middleware_chain.invoke(metadata) do
          activity_class.execute_in_context(context, deserialize(task.input))
        end

        # Do not complete asynchronous activities, these should be completed manually
        respond_completed(result) unless context.async?
      rescue StandardError, ScriptError => error
        respond_failed(error.class.name, error.message)
        Cadence::ErrorHandler.handle(error, metadata: metadata)
      rescue Exception => error
        Cadence.logger.fatal("Activity #{activity_log_name} unexpectedly failed with: #{error.inspect}")
        Cadence.logger.debug(error.backtrace.join("\n"))
        Cadence::ErrorHandler.handle(error, metadata: metadata)
        raise
      ensure
        time_diff_ms = ((Time.now - start_time) * 1000).round
        Cadence.metrics.timing('activity_task.latency', time_diff_ms, activity: activity_name)
        Cadence.logger.debug("Activity task processed in #{time_diff_ms}ms")
      end

      private

      attr_reader :task, :domain, :task_token, :workflow_name, :workflow_id, 
        :activity_name, :activity_id, :activity_class, :middleware_chain, :config, :metadata

      def connection
        @connection ||= Cadence::Connection.generate(config.for_connection)
      end

      def queue_time_ms
        ((task.startedTimestamp - task.scheduledTimestampOfThisAttempt) / 1_000_000).round
      end

      def respond_completed(result)
        Cadence.logger.info("Activity #{activity_log_name} completed")
        connection.respond_activity_task_completed(task_token: task_token, result: result)
      rescue StandardError => error
        Cadence.logger.error("Unable to complete Activity #{activity_log_name}: #{error.inspect}")
        Cadence::ErrorHandler.handle(error, metadata: metadata)
      end

      def respond_failed(reason, details)
        Cadence.logger.error("Activity #{activity_log_name} failed with: #{reason}")
        connection.respond_activity_task_failed(task_token: task_token, reason: reason, details: details)
      rescue StandardError => error
        Cadence.logger.error("Unable to fail Activity #{activity_log_name}: #{error.inspect}")
        Cadence::ErrorHandler.handle(error, metadata: metadata)
      end

      def activity_log_name
        "#{activity_name} (#{activity_id}) of #{workflow_name} (#{workflow_id})"
      end
    end
  end
end
