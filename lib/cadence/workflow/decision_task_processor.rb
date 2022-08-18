require 'cadence/workflow/executor'
require 'cadence/workflow/history'
require 'cadence/workflow/serializer'
require 'cadence/metadata'
require 'cadence/error_handler'

module Cadence
  class Workflow
    class DecisionTaskProcessor
      Query = Struct.new(:query) do

        def query_type
          query.queryType
        end

        def query_args
          JSON.deserialize(query.queryArgs)
        end
      end

      MAX_FAILED_ATTEMPTS = 50
      LEGACY_QUERY_KEY = :legacy_query

      def initialize(task, domain, workflow_lookup, middleware_chain, config)
        @task = task
        @domain = domain
        @metadata = Metadata.generate(Metadata::DECISION_TYPE, task, domain)
        @task_token = task.taskToken
        @workflow_name = task.workflowType.name
        @workflow_class = workflow_lookup.find(workflow_name)
        @middleware_chain = middleware_chain
        @config = config
      end

      def process
        start_time = Time.now

        Cadence.logger.info("Processing a decision task for #{workflow_name}")
        Cadence.metrics.timing('decision_task.queue_time', queue_time_ms, workflow: workflow_name)

        unless workflow_class
          fail_task('Workflow does not exist')
          return
        end

        history = fetch_full_history
        # TODO: For sticky workflows we need to cache the Executor instance
        executor = Workflow::Executor.new(workflow_class, history, metadata, config)

        decisions = middleware_chain.invoke(metadata) do
          executor.run
        end

        query_results = executor.process_queries(parse_queries)

        if legacy_query_task?
          complete_query(query_results[LEGACY_QUERY_KEY])
        else
          complete_task(commands, query_results)
        end

      rescue StandardError => error
        fail_task(error.inspect)
        Cadence.logger.debug(error.backtrace.join("\n"))
        Cadence::ErrorHandler.handle(error, metadata: metadata)
      ensure
        time_diff_ms = ((Time.now - start_time) * 1000).round
        Cadence.metrics.timing('decision_task.latency', time_diff_ms, workflow: workflow_name)
        Cadence.logger.debug("Decision task processed in #{time_diff_ms}ms")
      end

      private

      attr_reader :task, :domain, :task_token, :workflow_name, :workflow_class,
                  :middleware_chain, :config, :metadata

      def connection
        @connection ||= Cadence::Connection.generate(config.for_connection)
      end

      def queue_time_ms
        ((task.startedTimestamp - task.scheduledTimestamp) / 1_000_000).round
      end

      def serialize_decisions(decisions)
        decisions.map { |(_, decision)| Workflow::Serializer.serialize(decision) }
      end

      def fetch_full_history
        events = task.history.events.to_a
        next_page_token = task.nextPageToken

        while next_page_token do
          response = connection.get_workflow_execution_history(
            domain: domain,
            workflow_id: task.workflowExecution.workflowId,
            run_id: task.workflowExecution.runId,
            next_page_token: next_page_token
          )

          events += response.history.events.to_a
          next_page_token = response.nextPageToken
        end

        Workflow::History.new(events)
      end

      def legacy_query_task?
        !!task.query
      end

      def parse_queries
        # Support for deprecated query style
        if legacy_query_task?
          { LEGACY_QUERY_KEY => Query.new(task.query) }
        else
          task.queries.each_with_object({}) do |(query_id, query), result|
            result[query_id] = Query.new(query)
          end
        end
      end

      def complete_task(commands, query_results)
        Cadence.logger.info("Decision task for #{workflow_name} completed")

        connection.respond_decision_task_completed(
          task_token: task_token,
          decisions: serialize_decisions(decisions),
          query_results: query_results
        )
      end

      def complete_query(result)
        Cadence.logger.info("Workflow Query task completed", metadata.to_h)

        connection.respond_query_task_completed(
          task_token: task_token,
          query_result: result
        )
      rescue StandardError => error
        Cadence.logger.error("Unable to complete a query", metadata.to_h.merge(error: error.inspect))

        Cadence::ErrorHandler.handle(error, config, metadata: metadata)
      end

      def fail_task(message)
        Cadence.logger.error("Decision task for #{workflow_name} failed with: #{message}")

        # Stop from getting into infinite loop if the error persists
        return if task.attempt >= MAX_FAILED_ATTEMPTS

        connection.respond_decision_task_failed(
          task_token: task_token,
          cause: CadenceThrift::DecisionTaskFailedCause::UNHANDLED_DECISION,
          details: message
        )
      rescue StandardError => error
        Cadence.logger.error("Unable to fail Decision task #{workflow_name}: #{error.inspect}")
        Cadence::ErrorHandler.handle(error, metadata: metadata)
      end
    end
  end
end
