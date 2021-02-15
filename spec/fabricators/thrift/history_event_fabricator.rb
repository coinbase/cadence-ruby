require 'gen/thrift/cadence_types'
require 'cadence/utils'
require 'securerandom'

Fabricator(:history_event_thrift, from: CadenceThrift::HistoryEvent) do
  eventId { 1 }
  timestamp { Cadence::Utils.time_to_nanos(Time.now) }
end

Fabricator(:workflow_execution_started_event_thrift, from: :history_event_thrift) do
  eventType { CadenceThrift::EventType::WorkflowExecutionStarted }
  workflowExecutionStartedEventAttributes do
    CadenceThrift::WorkflowExecutionStartedEventAttributes.new(
      workflowType: Fabricate(:workflow_type_thrift),
      taskList: Fabricate(:task_list_thrift),
      input: nil,
      executionStartToCloseTimeoutSeconds: 60,
      taskStartToCloseTimeoutSeconds: 15,
      originalExecutionRunId: SecureRandom.uuid,
      identity: 'test-worker@test-host',
      firstExecutionRunId: SecureRandom.uuid,
      retryPolicy: nil,
      attempt: 0,
      header: Fabricate(:header_thrift)
    )
  end
end

Fabricator(:workflow_execution_completed_event_thrift, from: :history_event_thrift) do
  eventType { CadenceThrift::EventType::WorkflowExecutionCompleted }
  workflowExecutionCompletedEventAttributes do |attrs|
    CadenceThrift::WorkflowExecutionCompletedEventAttributes.new(
      result: nil,
      decisionTaskCompletedEventId: attrs[:eventId] - 1
    )
  end
end

Fabricator(:decision_task_scheduled_event_thrift, from: :history_event_thrift) do
  eventType { CadenceThrift::EventType::DecisionTaskScheduled }
  decisionTaskScheduledEventAttributes do |attrs|
    CadenceThrift::DecisionTaskScheduledEventAttributes.new(
      taskList: Fabricate(:task_list_thrift),
      startToCloseTimeoutSeconds: 15,
      attempt: 0
    )
  end
end

Fabricator(:decision_task_started_event_thrift, from: :history_event_thrift) do
  eventType { CadenceThrift::EventType::DecisionTaskStarted }
  decisionTaskStartedEventAttributes do |attrs|
    CadenceThrift::DecisionTaskStartedEventAttributes.new(
      scheduledEventId: attrs[:eventId] - 1,
      identity: 'test-worker@test-host',
      requestId: SecureRandom.uuid
    )
  end
end

Fabricator(:decision_task_completed_event_thrift, from: :history_event_thrift) do
  eventType { CadenceThrift::EventType::DecisionTaskCompleted }
  decisionTaskCompletedEventAttributes do |attrs|
    CadenceThrift::DecisionTaskCompletedEventAttributes.new(
      scheduledEventId: attrs[:eventId] - 2,
      startedEventId: attrs[:eventId] - 1,
      identity: 'test-worker@test-host'
    )
  end
end
