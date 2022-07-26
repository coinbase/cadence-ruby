require 'fiber'

require 'cadence/workflow/dispatcher'
require 'cadence/workflow/query_registry'
require 'cadence/workflow/state_manager'
require 'cadence/workflow/context'
require 'cadence/workflow/history/event_target'
require 'cadence/metadata'

module Cadence
  class Workflow
    class Executor
      def initialize(workflow_class, history, metadata, config)
        @workflow_class = workflow_class
        @dispatcher = Dispatcher.new
        @query_registry = QueryRegistry.new
        @state_manager = StateManager.new(dispatcher)
        @metadata = metadata
        @history = history
        @config = config
      end

      def run
        dispatcher.register_handler(
          History::EventTarget.workflow,
          'started',
          &method(:execute_workflow)
        )

        while window = history.next_window
          state_manager.apply(window)
        end

        return state_manager.decisions
      end

      # Process queries using the pre-registered query handlers
      #
      # @note this method is expected to be executed after the history has
      #   been fully replayed (by invoking the #run method)
      #
      # @param queries [Hash<String, Cadence::Workflow::TaskProcessor::Query>]
      #
      # @return [Hash<String, Cadence::Workflow::QueryResult>]
      def process_queries(queries = {})
        queries.transform_values(&method(:process_query))
      end

      private

      attr_reader :workflow_class, :dispatcher, :state_manager, :metadata, :history, :config, :query_registry

      def process_query(query)
        result = query_registry.handle(query.query_type, query.query_args)

        QueryResult.answer(result)
      rescue StandardError => error
        QueryResult.failure(error)
      end

      def execute_workflow(input, workflow_started_event_attributes)
        metadata = generate_workflow_metadata_from(workflow_started_event_attributes)
        context = Workflow::Context.new(state_manager, dispatcher, metadata, config, query_registry)

        Fiber.new do
          workflow_class.execute_in_context(context, input)
        end.resume
      end

      # workflow_id and domain are confusingly not available on the WorkflowExecutionStartedEvent,
      # so we have to fetch these from the DecisionTask's metadata
      def generate_workflow_metadata_from(event_attributes)
        Metadata::Workflow.new(
          domain: metadata.domain,
          id: metadata.workflow_id,
          name: event_attributes.workflowType.name,
          run_id: event_attributes.originalExecutionRunId,
          attempt: event_attributes.attempt,
          headers: event_attributes.header&.fields || {},
          timeouts: {
            execution: event_attributes.executionStartToCloseTimeoutSeconds,
            task: event_attributes.taskStartToCloseTimeoutSeconds
          }
        )
      end
    end
  end
end
