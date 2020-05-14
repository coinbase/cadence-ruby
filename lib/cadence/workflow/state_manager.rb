require 'cadence/json'
require 'cadence/errors'
require 'cadence/workflow/decision'
require 'cadence/workflow/decision_state_machine'
require 'cadence/workflow/history/event_target'
require 'cadence/metadata'

module Cadence
  class Workflow
    class StateManager
      class UnsupportedEvent < Cadence::InternalError; end

      attr_reader :decisions, :local_time

      def initialize(dispatcher)
        @dispatcher = dispatcher
        @decisions = []
        @marker_ids = Set.new
        @markers = Hash.new { |hash, key| hash[key] = [] }
        @decision_tracker = Hash.new { |hash, key| hash[key] = DecisionStateMachine.new }
        @last_event_id = 0
        @local_time = nil
        @replay = false
      end

      def replay?
        @replay
      end

      def schedule(decision)
        # Fast-forward event IDs to skip all the markers (version markers can
        # be removed, so we can't rely on them being scheduled during a replay)
        decision_id = next_event_id
        while marker_ids.include?(decision_id) do
          decision_id = next_event_id
        end

        cancelation_id =
          case decision
          when Decision::ScheduleActivity
            decision.activity_id ||= decision_id
          when Decision::StartChildWorkflow
            decision.workflow_id ||= decision_id
          when Decision::StartTimer
            decision.timer_id ||= decision_id
          end

        state_machine = decision_tracker[decision_id]
        state_machine.requested if state_machine.state == DecisionStateMachine::NEW_STATE

        decisions << [decision_id, decision]

        return [event_target_from(decision_id, decision), cancelation_id]
      end

      def next_marker(type)
        markers[type].shift
      end

      def apply(history_window)
        @replay = history_window.replay?
        @local_time = history_window.local_time
        @last_event_id = history_window.last_event_id

        # handle markers first since their data is needed for processing events
        history_window.markers.each do |id, type, details|
          marker_ids << id
          markers[type] << [id, JSON.deserialize(details)]
        end

        history_window.events.each do |event|
          apply_event(event)
        end
      end

      private

      attr_reader :dispatcher, :decision_tracker, :markers, :marker_ids

      def next_event_id
        @last_event_id += 1
      end

      def apply_event(event)
        state_machine = decision_tracker[event.decision_id]
        target = History::EventTarget.from_event(event)

        case event.type
        when 'WorkflowExecutionStarted'
          state_machine.start
          dispatch(
            History::EventTarget.workflow,
            'started',
            safe_parse(event.attributes.input),
            Metadata.generate(Metadata::WORKFLOW_TYPE, event.attributes)
          )

        when 'WorkflowExecutionCompleted'
          # todo

        when 'WorkflowExecutionFailed'
          # todo

        when 'WorkflowExecutionTimedOut'
          # todo

        when 'DecisionTaskScheduled'
          # todo

        when 'DecisionTaskStarted'
          # todo

        when 'DecisionTaskCompleted'
          # todo

        when 'DecisionTaskTimedOut'
          # todo

        when 'DecisionTaskFailed'
          # todo

        when 'ActivityTaskScheduled'
          state_machine.schedule
          discard_decision(event.decision_id)

        when 'ActivityTaskStarted'
          state_machine.start

        when 'ActivityTaskCompleted'
          state_machine.complete
          dispatch(target, 'completed', safe_parse(event.attributes.result))

        when 'ActivityTaskFailed'
          state_machine.fail
          dispatch(target, 'failed', event.attributes.reason, safe_parse(event.attributes.details))

        when 'ActivityTaskTimedOut'
          state_machine.time_out
          type = CadenceThrift::TimeoutType::VALUE_MAP[event.attributes.timeoutType]
          dispatch(target, 'failed', 'Cadence::TimeoutError', "Timeout type: #{type}")

        when 'ActivityTaskCancelRequested'
          state_machine.requested
          discard_decision(event.decision_id)

        when 'RequestCancelActivityTaskFailed'
          state_machine.fail
          dispatch(target, 'failed', event.attributes.cause, nil)

        when 'ActivityTaskCanceled'
          state_machine.cancel
          dispatch(target, 'failed', 'CANCELLED', safe_parse(event.attributes.details))

        when 'TimerStarted'
          state_machine.start
          discard_decision(event.decision_id)

        when 'TimerFired'
          state_machine.complete
          dispatch(target, 'fired')

        when 'CancelTimerFailed'
          state_machine.failed
          dispatch(target, 'failed', event.attributes.cause, nil)

        when 'TimerCanceled'
          state_machine.cancel
          dispatch(target, 'canceled')

        when 'WorkflowExecutionCancelRequested'
          # todo

        when 'WorkflowExecutionCanceled'
          # todo

        when 'RequestCancelExternalWorkflowExecutionInitiated'
          # todo

        when 'RequestCancelExternalWorkflowExecutionFailed'
          # todo

        when 'ExternalWorkflowExecutionCancelRequested'
          # todo

        when 'MarkerRecorded'
          # no-op

        when 'WorkflowExecutionSignaled'
          dispatch(target, 'signaled', event.attributes.signalName, safe_parse(event.attributes.input))

        when 'WorkflowExecutionTerminated'
          # todo

        when 'WorkflowExecutionContinuedAsNew'
          # todo

        when 'StartChildWorkflowExecutionInitiated'
          state_machine.schedule
          discard_decision(event.decision_id)

        when 'StartChildWorkflowExecutionFailed'
          state_machine.fail
          dispatch(target, 'failed', 'StandardError', safe_parse(event.attributes.cause))

        when 'ChildWorkflowExecutionStarted'
          state_machine.start

        when 'ChildWorkflowExecutionCompleted'
          state_machine.complete
          dispatch(target, 'completed', safe_parse(event.attributes.result))

        when 'ChildWorkflowExecutionFailed'
          state_machine.fail
          dispatch(target, 'failed', event.attributes.reason, safe_parse(event.attributes.details))

        when 'ChildWorkflowExecutionCanceled'
          state_machine.cancel
          dispatch(target, 'failed', 'CANCELLED', safe_parse(event.attributes.details))

        when 'ChildWorkflowExecutionTimedOut'
          state_machine.time_out
          type = CadenceThrift::TimeoutType::VALUE_MAP[event.attributes.timeoutType]
          dispatch(target, 'failed', 'Cadence::TimeoutError', "Timeout type: #{type}")

        when 'ChildWorkflowExecutionTerminated'
          # todo

        when 'SignalExternalWorkflowExecutionInitiated'
          # todo

        when 'SignalExternalWorkflowExecutionFailed'
          # todo

        when 'ExternalWorkflowExecutionSignaled'
          # todo

        when 'UpsertWorkflowSearchAttributes'
          # todo

        else
          raise UnsupportedEvent, event.type
        end
      end

      def event_target_from(decision_id, decision)
        target_type =
          case decision
          when Decision::ScheduleActivity
            History::EventTarget::ACTIVITY_TYPE
          when Decision::RequestActivityCancellation
            History::EventTarget::CANCEL_ACTIVITY_REQUEST_TYPE
          when Decision::RecordMarker
            History::EventTarget::MARKER_TYPE
          when Decision::StartTimer
            History::EventTarget::TIMER_TYPE
          when Decision::CancelTimer
            History::EventTarget::CANCEL_TIMER_REQUEST_TYPE
          when Decision::CompleteWorkflow, Decision::FailWorkflow
            History::EventTarget::WORKFLOW_TYPE
          when Decision::StartChildWorkflow
            History::EventTarget::CHILD_WORKFLOW_TYPE
          end

        History::EventTarget.new(decision_id, target_type)
      end

      def dispatch(target, name, *attributes)
        dispatcher.dispatch(target, name, attributes)
      end

      def discard_decision(decision_id)
        decisions.delete_if { |(id, _)| id == decision_id }
      end

      def safe_parse(binary)
        JSON.deserialize(binary)
      end
    end
  end
end
