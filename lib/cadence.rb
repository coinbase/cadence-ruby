require 'securerandom'
require 'cadence/configuration'
require 'cadence/execution_options'
require 'cadence/connection'
require 'cadence/activity'
require 'cadence/activity/async_token'
require 'cadence/workflow'
require 'cadence/workflow/history'
require 'cadence/workflow/execution_info'
require 'cadence/metrics'

module Cadence
  class << self
    def start_workflow(workflow, *input, **args)
      options = args.delete(:options) || {}
      input << args unless args.empty?

      execution_options = ExecutionOptions.new(workflow, options)
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

      execution_options = ExecutionOptions.new(workflow, options)
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

    def reset_workflow(domain, workflow_id, run_id, decision_task_id: nil, reason: 'manual reset')
      decision_task_id ||= get_last_completed_decision_task(domain, workflow_id, run_id)
      raise Error, 'Could not find a completed decision task event' unless decision_task_id

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

    def configure(&block)
      yield configuration
    end

    def configuration
      @configuration ||= Configuration.new
    end

    def logger
      configuration.logger
    end

    def metrics
      @metrics ||= Metrics.new(configuration.metrics_adapter)
    end

    def get_workflow_history(domain:, workflow_id:, run_id:)
      history_response = connection.get_workflow_execution_history(
        domain: domain,
        workflow_id: workflow_id,
        run_id: run_id
      )
      Workflow::History.new(history_response.history.events)
    end

    private

    def connection
      @connection ||= Cadence::Connection.generate
    end

    def get_last_completed_decision_task(domain, workflow_id, run_id)
      history = get_workflow_history(
        domain: domain,
        workflow_id: workflow_id,
        run_id: run_id
      )

      decision_task_event = history.last_completed_decision_task

      decision_task_event&.id
    end
  end
end
