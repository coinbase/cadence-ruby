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

Fabricator(:activity_task_scheduled_event_thrift, from: :history_event_thrift) do
  eventType { CadenceThrift::EventType::ActivityTaskScheduled }
  activityTaskScheduledEventAttributes do |attrs|
    CadenceThrift::ActivityTaskScheduledEventAttributes.new(
      activityId: attrs[:eventId],
      activityType: CadenceThrift::ActivityType.new(name: 'TestActivity'),
      decisionTaskCompletedEventId: attrs[:eventId] - 1,
      domain: 'test-domain',
      taskList: Fabricate(:task_list_thrift)
    )
  end
end

Fabricator(:activity_task_started_event_thrift, from: :history_event_thrift) do
  eventType { CadenceThrift::EventType::ActivityTaskStarted }
  activityTaskStartedEventAttributes do |attrs|
    CadenceThrift::ActivityTaskStartedEventAttributes.new(
      scheduledEventId: attrs[:eventId] - 1,
      identity: 'test-worker@test-host',
      requestId: SecureRandom.uuid
    )
  end
end

Fabricator(:activity_task_completed_event_thrift, from: :history_event_thrift) do
  eventType { CadenceThrift::EventType::ActivityTaskCompleted }
  activityTaskCompletedEventAttributes do |attrs|
    CadenceThrift::ActivityTaskCompletedEventAttributes.new(
      result: nil,
      scheduledEventId: attrs[:eventId] - 2,
      startedEventId: attrs[:eventId] - 1,
      identity: 'test-worker@test-host'
    )
  end
end

Fabricator(:activity_task_failed_event_thrift, from: :history_event_thrift) do
  eventType { CadenceThrift::EventType::ActivityTaskFailed }
  activityTaskFailedEventAttributes do |attrs|
    CadenceThrift::ActivityTaskFailedEventAttributes.new(
      reason: 'StandardError',
      details: 'Activity failed',
      scheduledEventId: attrs[:eventId] - 2,
      startedEventId: attrs[:eventId] - 1,
      identity: 'test-worker@test-host'
    )
  end
end

Fabricator(:timer_started_event_thrift, from: :history_event_thrift) do
  eventType { CadenceThrift::EventType::TimerStarted }
  timerStartedEventAttributes do |attrs|
    CadenceThrift::TimerStartedEventAttributes.new(
      timerId: attrs[:eventId],
      startToFireTimeoutSeconds: 10,
      decisionTaskCompletedEventId: attrs[:eventId] - 1
    )
  end
end

Fabricator(:timer_fired_event_thrift, from: :history_event_thrift) do
  eventType { CadenceThrift::EventType::TimerFired }
  timerFiredEventAttributes do |attrs|
    CadenceThrift::TimerFiredEventAttributes.new(
      timerId: attrs[:eventId],
      startedEventId: attrs[:eventId] - 4
    )
  end
end

Fabricator(:timer_canceled_event_thrift, from: :history_event_thrift) do
  eventType { CadenceThrift::EventType::TimerCanceled }
  timerCanceledEventAttributes do |attrs|
    CadenceThrift::TimerCanceledEventAttributes.new(
      timerId: attrs[:eventId],
      startedEventId: attrs[:eventId] - 4,
      decisionTaskCompletedEventId: attrs[:eventId] - 1,
      identity: 'test-worker@test-host'
    )
  end
end
