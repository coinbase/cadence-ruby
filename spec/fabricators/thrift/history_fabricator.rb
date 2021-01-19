require 'gen/thrift/cadence_types'

Fabricator(:history_thrift, from: CadenceThrift::History) do
  events do
    [
      Fabricate(:workflow_execution_started_event_thrift, eventId: 1),
      Fabricate(:decision_task_scheduled_event_thrift, eventId: 2),
      Fabricate(:decision_task_started_event_thrift, eventId: 3),
      Fabricate(:decision_task_completed_event_thrift, eventId: 4),
      Fabricate(:workflow_execution_completed_event_thrift, eventId: 5)
    ]
  end
end
