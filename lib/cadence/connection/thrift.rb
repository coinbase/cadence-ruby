require 'thrift'
require 'securerandom'
require 'cadence/json'
require 'cadence/connection/errors'
require 'cadence/utils'
require 'gen/thrift/workflow_service'

module Cadence
  module Connection
    class Thrift
      WORKFLOW_ID_REUSE_POLICY = {
        allow_failed: CadenceThrift::WorkflowIdReusePolicy::AllowDuplicateFailedOnly,
        allow: CadenceThrift::WorkflowIdReusePolicy::AllowDuplicate,
        reject: CadenceThrift::WorkflowIdReusePolicy::RejectDuplicate
      }.freeze

      QUERY_REJECT_CONDITION = {
        # none: CadenceThrift::QueryRejectCondition::NONE,
        not_open: CadenceThrift::QueryRejectCondition::NOT_OPEN,
        not_completed_cleanly: CadenceThrift::QueryRejectCondition::NOT_COMPLETED_CLEANLY
      }.freeze

      DEFAULT_OPTIONS = {
        polling_ttl: 60, # 1 minute
        max_page_size: 100
      }.freeze

      HISTORY_EVENT_FILTER = {
        all: CadenceThrift::HistoryEventFilterType::ALL_EVENT,
        close: CadenceThrift::HistoryEventFilterType::CLOSE_EVENT,
      }.freeze

      def initialize(host, port, identity, options = {})
        @url = "http://#{host}:#{port}"
        @identity = identity
        @options = DEFAULT_OPTIONS.merge(options)
        @mutex = Mutex.new
      end

      def register_domain(name:, description: nil, global: false, metrics: false, retention_period: 10)
        request = CadenceThrift::RegisterDomainRequest.new(
          name: name,
          description: description,
          emitMetric: metrics,
          isGlobalDomain: global,
          workflowExecutionRetentionPeriodInDays: retention_period
        )
        send_request('RegisterDomain', request)
      end

      def describe_domain(name:)
        request = CadenceThrift::DescribeDomainRequest.new(name: name)
        send_request('DescribeDomain', request)
      end

      def list_domains(page_size:)
        request = CadenceThrift::ListDomainsRequest.new(pageSize: page_size)
        send_request('ListDomains', request)
      end

      def update_domain(name:, description:)
        request = CadenceThrift::UpdateDomainRequest.new(
          name: name,
          updateInfo: CadenceThrift::UpdateDomainRequest.new(
            description: description
          )
        )
        send_request('UpdateDomain', request)
      end

      def deprecate_domain(name:)
        request = CadenceThrift::DeprecateDomainRequest.new(name: name)
        send_request('DeprecateDomain', request)
      end

      def start_workflow_execution(
        domain:,
        workflow_id:,
        workflow_name:,
        task_list:,
        input: nil,
        execution_timeout:,
        task_timeout:,
        workflow_id_reuse_policy: nil,
        headers: nil,
        cron_schedule: nil
      )
        request = CadenceThrift::StartWorkflowExecutionRequest.new(
          identity: identity,
          domain: domain,
          workflowType: CadenceThrift::WorkflowType.new(
            name: workflow_name
          ),
          workflowId: workflow_id,
          taskList: CadenceThrift::TaskList.new(
            name: task_list
          ),
          input: JSON.serialize(input),
          executionStartToCloseTimeoutSeconds: execution_timeout,
          taskStartToCloseTimeoutSeconds: task_timeout,
          requestId: SecureRandom.uuid,
          header: CadenceThrift::Header.new(
            fields: headers
          ),
          cronSchedule: cron_schedule
        )

        if workflow_id_reuse_policy
          policy = WORKFLOW_ID_REUSE_POLICY[workflow_id_reuse_policy]
          raise Client::ArgumentError, 'Unknown workflow_id_reuse_policy specified' unless policy

          request.workflowIdReusePolicy = policy
        end

        send_request('StartWorkflowExecution', request)
      end

      def get_workflow_execution_history(
        domain:,
        workflow_id:,
        run_id:,
        next_page_token: nil,
        wait_for_new_event: false,
        event_type: :all
      )
        request = CadenceThrift::GetWorkflowExecutionHistoryRequest.new(
          domain: domain,
          execution: CadenceThrift::WorkflowExecution.new(
            workflowId: workflow_id,
            runId: run_id
          ),
          nextPageToken: next_page_token,
          waitForNewEvent: wait_for_new_event,
          HistoryEventFilterType: HISTORY_EVENT_FILTER[event_type]
        )

        send_request('GetWorkflowExecutionHistory', request)
      end

      def poll_for_decision_task(domain:, task_list:)
        request = CadenceThrift::PollForDecisionTaskRequest.new(
          identity: identity,
          domain: domain,
          taskList: CadenceThrift::TaskList.new(
            name: task_list
          )
        )
        send_request('PollForDecisionTask', request)
      end

      def respond_decision_task_completed(task_token:, decisions:, query_results: {})
        request = CadenceThrift::RespondDecisionTaskCompletedRequest.new(
          identity: identity,
          taskToken: task_token,
          decisions: Array(decisions),
          queryResults: query_results.transform_values { |value| Serializer.serialize(value) }
        )
        send_request('RespondDecisionTaskCompleted', request)
      end

      def respond_decision_task_failed(task_token:, cause:, details: nil)
        request = CadenceThrift::RespondDecisionTaskFailedRequest.new(
          identity: identity,
          taskToken: task_token,
          cause: cause,
          details: JSON.serialize(details)
        )
        send_request('RespondDecisionTaskFailed', request)
      end

      def poll_for_activity_task(domain:, task_list:)
        request = CadenceThrift::PollForActivityTaskRequest.new(
          identity: identity,
          domain: domain,
          taskList: CadenceThrift::TaskList.new(
            name: task_list
          )
        )
        send_request('PollForActivityTask', request)
      end

      def record_activity_task_heartbeat(task_token:, details: nil)
        request = CadenceThrift::RecordActivityTaskHeartbeatRequest.new(
          taskToken: task_token,
          details: JSON.serialize(details),
          identity: identity
        )
        send_request('RecordActivityTaskHeartbeat', request)
      end

      def record_activity_task_heartbeat_by_id
        raise NotImplementedError
      end

      def respond_activity_task_completed(task_token:, result:)
        request = CadenceThrift::RespondActivityTaskCompletedRequest.new(
          identity: identity,
          taskToken: task_token,
          result: JSON.serialize(result)
        )
        send_request('RespondActivityTaskCompleted', request)
      end

      def respond_activity_task_completed_by_id(domain:, activity_id:, workflow_id:, run_id:, result:)
        request = CadenceThrift::RespondActivityTaskCompletedByIDRequest.new(
          identity: identity,
          domain: domain,
          workflowID: workflow_id,
          runID: run_id,
          activityID: activity_id,
          result: JSON.serialize(result)
        )
        send_request('RespondActivityTaskCompletedByID', request)
      end

      def respond_activity_task_failed(task_token:, reason:, details: nil)
        request = CadenceThrift::RespondActivityTaskFailedRequest.new(
          identity: identity,
          taskToken: task_token,
          reason: reason,
          details: JSON.serialize(details)
        )
        send_request('RespondActivityTaskFailed', request)
      end

      def respond_activity_task_failed_by_id(domain:, activity_id:, workflow_id:, run_id:, reason:, details: nil)
        request = CadenceThrift::RespondActivityTaskFailedByIDRequest.new(
          identity: identity,
          domain: domain,
          workflowID: workflow_id,
          runID: run_id,
          activityID: activity_id,
          reason: reason,
          details: JSON.serialize(details)
        )
        send_request('RespondActivityTaskFailedByID', request)
      end

      def respond_activity_task_canceled(task_token:, details: nil)
        request = CadenceThrift::RespondActivityTaskCanceledRequest.new(
          taskToken: task_token,
          details: JSON.serialize(details),
          identity: identity
        )
        send_request('RespondActivityTaskCanceled', request)
      end

      def respond_activity_task_canceled_by_id
        raise NotImplementedError
      end

      def request_cancel_workflow_execution
        raise NotImplementedError
      end

      def signal_workflow_execution(domain:, workflow_id:, run_id:, signal:, input: nil)
        request = CadenceThrift::SignalWorkflowExecutionRequest.new(
          domain: domain,
          workflowExecution: CadenceThrift::WorkflowExecution.new(
            workflowId: workflow_id,
            runId: run_id
          ),
          signalName: signal,
          input: JSON.serialize(input),
          identity: identity
        )
        send_request('SignalWorkflowExecution', request)
      end

      def signal_with_start_workflow_execution
        raise NotImplementedError
      end

      def reset_workflow_execution(domain:, workflow_id:, run_id:, reason:, decision_task_event_id:)
        request = CadenceThrift::ResetWorkflowExecutionRequest.new(
          domain: domain,
          workflowExecution: CadenceThrift::WorkflowExecution.new(
            workflowId: workflow_id,
            runId: run_id
          ),
          reason: reason,
          decisionFinishEventId: decision_task_event_id,
          requestId: SecureRandom.uuid
        )
        send_request('ResetWorkflowExecution', request)
      end

      def terminate_workflow_execution(domain:, workflow_id:, run_id:, reason:, details: nil)
        request = CadenceThrift::TerminateWorkflowExecutionRequest.new(
          domain: domain,
          workflowExecution: CadenceThrift::WorkflowExecution.new(
            workflowId: workflow_id,
            runId: run_id
          ),
          reason: reason,
          details: JSON.serialize(details),
          identity: identity
        )
        send_request('TerminateWorkflowExecution', request)
      end

      def list_open_workflow_executions(domain:, from:, to:, next_page_token: nil, workflow_id: nil, workflow: nil)
        request = CadenceThrift::ListOpenWorkflowExecutionsRequest.new(
          domain: domain,
          maximumPageSize: options[:max_page_size],
          nextPageToken: next_page_token,
          StartTimeFilter: serialize_time_filter(from, to),
          executionFilter: serialize_execution_filter(workflow_id),
          typeFilter: serialize_type_filter(workflow)
        )
        send_request('ListOpenWorkflowExecutions', request)
      end

      def list_closed_workflow_executions(domain:, from:, to:, next_page_token: nil, workflow_id: nil, workflow: nil, status: nil)
        request = CadenceThrift::ListClosedWorkflowExecutionsRequest.new(
          domain: domain,
          maximumPageSize: options[:max_page_size],
          nextPageToken: next_page_token,
          StartTimeFilter: serialize_time_filter(from, to),
          executionFilter: serialize_execution_filter(workflow_id),
          typeFilter: serialize_type_filter(workflow),
          statusFilter: serialize_status_filter(status)
        )
        send_request('ListClosedWorkflowExecutions', request)
      end

      def list_workflow_executions
        raise NotImplementedError
      end

      def list_archived_workflow_executions
        raise NotImplementedError
      end

      def scan_workflow_executions
        raise NotImplementedError
      end

      def count_workflow_executions
        raise NotImplementedError
      end

      def get_search_attributes
        raise NotImplementedError
      end

      def respond_query_task_completed(task_token:, query_result:)
        query_result_thrift = Serializer.serialize(query_result)
        request = CadenceThrift::RespondQueryTaskCompletedRequest.new(
          taskToken: task_token,
          completedType: query_result_thrift.result_type,
          queryResult: query_result_thrift.answer,
          errorMessage: query_result_thrift.error_message,
        )

        client.respond_query_task_completed(request)
      end

      def reset_sticky_task_list
        raise NotImplementedError
      end

      def query_workflow(domain:, workflow_id:, run_id:, query:, args: nil, query_reject_condition: nil)
        request = CadenceThrift::QueryWorkflowRequest.new(
          domain: domain,
          execution: CadenceThrift::WorkflowExecution.new(
            workflowId: workflow_id,
            runId: run_id
          ),
          query: CadenceThrift::WorkflowQuery.new(
            queryType: query,
            queryArgs: JSON.serialize(args)
          )
        )
        if query_reject_condition
          condition = QUERY_REJECT_CONDITION[query_reject_condition]
          raise Client::ArgumentError, 'Unknown query_reject_condition specified' unless condition

          request.query_reject_condition = condition
        end

        begin
          response = client.query_workflow(request)
          puts(response)
          # rescue InvalidArgument => e doesn't seem to work
          #
        rescue Error => e
          raise Cadence::QueryFailed, e.details
        end

        if response.query_rejected
          rejection_status = response.query_rejected.status || 'not specified by server'
          raise Cadence::QueryFailed, "Query rejected: status #{rejection_status}"
        elsif !response.query_result
          raise Cadence::QueryFailed, 'Invalid response from server'
        else
          JSON.deserialize(response.query_result)
        end
      end

      def describe_workflow_execution(domain:, workflow_id:, run_id:)
        request = CadenceThrift::DescribeWorkflowExecutionRequest.new(
          domain: domain,
          execution: CadenceThrift::WorkflowExecution.new(
            workflowId: workflow_id,
            runId: run_id
          )
        )
        send_request('DescribeWorkflowExecution', request)
      end

      def describe_task_list(domain:, task_list:)
        request = CadenceThrift::DescribeTaskListRequest.new(
          domain: domain,
          taskList: CadenceThrift::TaskList.new(
            name: task_list
          ),
          taskListType: CadenceThrift::TaskListType::Decision,
          includeTaskListStatus: true
        )
        send_request('DescribeTaskList', request)
      end

      private

      attr_reader :url, :identity, :options, :mutex

      def transport
        @transport ||= ::Thrift::HTTPClientTransport.new(url).tap do |http|
          http.add_headers(
            'Rpc-Caller' => 'ruby-client',
            'Rpc-Encoding' => 'thrift',
            'Rpc-Service' => 'cadence-proxy',
            'Context-TTL-MS' => (options[:polling_ttl] * 1_000).to_s
          )
        end
      end

      def connection
        @connection ||= begin
                          protocol = ::Thrift::BinaryProtocol.new(transport)
                          CadenceThrift::WorkflowService::Client.new(protocol)
                        end
      end

      def send_request(name, request)
        start_time = Time.now

        # synchronize these calls because transport headers are mutated
        result = mutex.synchronize do
          transport.add_headers 'Rpc-Procedure' => "WorkflowService::#{name}"
          connection.public_send(name, request)
        end

        time_diff_ms = ((Time.now - start_time) * 1000).round
        Cadence.metrics.timing('request.latency', time_diff_ms, request_name: name)

        result
      end

      def serialize_time_filter(from, to)
        CadenceThrift::StartTimeFilter.new(
          earliestTime: Cadence::Utils.time_to_nanos(from).to_i,
          latestTime: Cadence::Utils.time_to_nanos(to).to_i,
        )
      end

      def serialize_execution_filter(value)
        return unless value

        CadenceThrift::WorkflowExecutionFilter.new(workflowId: value)
      end

      def serialize_type_filter(value)
        return unless value

        CadenceThrift::WorkflowTypeFilter.new(name: value)
      end

      def serialize_status_filter(value)
        return unless value

        CadenceThrift::WorkflowExecutionCloseStatus::VALUE_MAP.invert[value.to_s]
      end
    end
  end
end