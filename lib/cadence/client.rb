require 'cadence/execution_options'
require 'cadence/connection'
require 'cadence/activity'
require 'cadence/activity/async_token'
require 'cadence/workflow'
require 'cadence/workflow/history'
require 'cadence/workflow/execution_info'
require 'cadence/workflow/status'
require 'cadence/reset_strategy'

module Cadence
  class Client
    def initialize(config)
      @config = config
    end

    def start_workflow(workflow, *input, **args)
      options = args.delete(:options) || {}
      input << args unless args.empty?

      execution_options = ExecutionOptions.new(workflow, options, config.default_execution_options)
      workflow_id = options[:workflow_id] || SecureRandom.uuid

      response = connection.start_workflow_execution(
        domain: execution_options.domain,
        workflow_id: workflow_id,
        workflow_name: execution_options.name,
        task_list: execution_options.task_list,
        input: input,
        execution_timeout: execution_options.timeouts[:execution],
        task_timeout: execution_options.timeouts[:task],
        workflow_id_reuse_policy: options[:workflow_id_reuse_policy],
        headers: execution_options.headers
      )

      response.runId
    end

    def schedule_workflow(workflow, cron_schedule, *input, **args)
      options = args.delete(:options) || {}
      input << args unless args.empty?

      execution_options = ExecutionOptions.new(workflow, options, config.default_execution_options)
      workflow_id = options[:workflow_id] || SecureRandom.uuid

      response = connection.start_workflow_execution(
        domain: execution_options.domain,
        workflow_id: workflow_id,
        workflow_name: execution_options.name,
        task_list: execution_options.task_list,
        input: input,
        execution_timeout: execution_options.timeouts[:execution],
        task_timeout: execution_options.timeouts[:task],
        workflow_id_reuse_policy: options[:workflow_id_reuse_policy],
        headers: execution_options.headers,
        cron_schedule: cron_schedule
      )

      response.runId
    end

    def register_domain(name, description = nil)
      connection.register_domain(name: name, description: description)
    rescue CadenceThrift::DomainAlreadyExistsError
      nil
    end

    def signal_workflow(workflow, signal, workflow_id, run_id, input = nil)
      connection.signal_workflow_execution(
        domain: workflow.domain, # TODO: allow passing domain instead
        workflow_id: workflow_id,
        run_id: run_id,
        signal: signal,
        input: input
      )
    end

    def reset_workflow(domain, workflow_id, run_id, strategy: nil, decision_task_id: nil, reason: 'manual reset')
      # Pick default strategy for backwards-compatibility
      strategy ||= :last_decision_task unless decision_task_id

      if strategy && decision_task_id
        raise ArgumentError, 'Please specify either :strategy or :decision_task_id'
      end

      decision_task_id ||= find_decision_task(domain, workflow_id, run_id, strategy)&.id
      raise Error, 'Could not find an event to reset to' unless decision_task_id

      response = connection.reset_workflow_execution(
        domain: domain,
        workflow_id: workflow_id,
        run_id: run_id,
        reason: reason,
        decision_task_event_id: decision_task_id
      )

      response.runId
    end

    def terminate_workflow(domain, workflow_id, run_id, reason: 'manual termination', details: nil)
      connection.terminate_workflow_execution(
        domain: domain,
        workflow_id: workflow_id,
        run_id: run_id,
        reason: reason,
        details: details
      )
    end

    def fetch_workflow_execution_info(domain, workflow_id, run_id)
      response = connection.describe_workflow_execution(
        domain: domain,
        workflow_id: workflow_id,
        run_id: run_id
      )

      Workflow::ExecutionInfo.generate_from(response.workflowExecutionInfo)
    end

    def complete_activity(async_token, result = nil)
      details = Activity::AsyncToken.decode(async_token)

      connection.respond_activity_task_completed_by_id(
        domain: details.domain,
        activity_id: details.activity_id,
        workflow_id: details.workflow_id,
        run_id: details.run_id,
        result: result
      )
    end

    def fail_activity(async_token, error)
      details = Activity::AsyncToken.decode(async_token)

      connection.respond_activity_task_failed_by_id(
        domain: details.domain,
        activity_id: details.activity_id,
        workflow_id: details.workflow_id,
        run_id: details.run_id,
        reason: error.class.name,
        details: error.message
      )
    end

    def get_workflow_history(domain:, workflow_id:, run_id:)
      history_response = connection.get_workflow_execution_history(
        domain: domain,
        workflow_id: workflow_id,
        run_id: run_id
      )
      Workflow::History.new(history_response.history.events)
    end

    def list_open_workflow_executions(domain, from, to = Time.now, filter: {})
      validate_filter(filter, :workflow, :workflow_id)

      fetch_executions(:open, { domain: domain, from: from, to: to }.merge(filter))
    end

    def list_closed_workflow_executions(domain, from, to = Time.now, filter: {})
      validate_filter(filter, :status, :workflow, :workflow_id)

      fetch_executions(:closed, { domain: domain, from: from, to: to }.merge(filter))
    end

    private

    attr_reader :config

    def connection
      @connection ||= Cadence::Connection.generate(config.for_connection)
    end

    def find_decision_task(domain, workflow_id, run_id, strategy)
      history = get_workflow_history(
        domain: domain,
        workflow_id: workflow_id,
        run_id: run_id
      )

      # TODO: Move this into a separate class if it keeps growing
      case strategy
      when ResetStrategy::LAST_DECISION_TASK
        events = %[DecisionTaskCompleted DecisionTaskTimedOut DecisionTaskFailed].freeze
        history.events.select { |event| events.include?(event.type) }.last
      when ResetStrategy::FIRST_DECISION_TASK
        events = %[DecisionTaskCompleted DecisionTaskTimedOut DecisionTaskFailed].freeze
        history.events.select { |event| events.include?(event.type) }.first
      when ResetStrategy::LAST_FAILED_ACTIVITY
        events = %[ActivityTaskFailed ActivityTaskTimedOut].freeze
        failed_event = history.events.select { |event| events.include?(event.type) }.last
        return unless failed_event

        scheduled_event = history.find_event_by_id(failed_event.attributes.scheduledEventId)
        history.find_event_by_id(scheduled_event.attributes.decisionTaskCompletedEventId)
      else
        raise ArgumentError, 'Unsupported reset strategy'
      end
    end

    def validate_filter(filter, *allowed_filters)
      if (filter.keys - allowed_filters).length > 0
        raise ArgumentError, "Allowed filters are: #{allowed_filters}"
      end

      raise ArgumentError, 'Only one filter is allowed' if filter.size > 1
    end

    def fetch_executions(status, request_options)
      api_method =
        if status == :open
          :list_open_workflow_executions
        else
          :list_closed_workflow_executions
        end

      executions = []
      next_page_token = nil

      loop do
        response = connection.public_send(
          api_method,
          **request_options.merge(next_page_token: next_page_token)
        )

        executions += Array(response.executions)
        next_page_token = response.nextPageToken

        break if next_page_token.to_s.empty?
      end

      executions.map do |raw_execution|
        Cadence::Workflow::ExecutionInfo.generate_from(raw_execution)
      end
    end
  end
end
