require 'cadence/errors'

module Cadence
  class Workflow
    class History
      class EventTarget
        class UnexpectedEventType < InternalError; end
        class UnexpectedDecisionType < InternalError; end

        ACTIVITY_TYPE                         = :activity
        CANCEL_ACTIVITY_REQUEST_TYPE          = :cancel_activity_request
        TIMER_TYPE                            = :timer
        CANCEL_TIMER_REQUEST_TYPE             = :cancel_timer_request
        CHILD_WORKFLOW_TYPE                   = :child_workflow
        MARKER_TYPE                           = :marker
        EXTERNAL_WORKFLOW_TYPE                = :external_workflow
        CANCEL_EXTERNAL_WORKFLOW_REQUEST_TYPE = :cancel_external_workflow_request
        WORKFLOW_TYPE                         = :workflow
        CANCEL_WORKFLOW_REQUEST_TYPE          = :cancel_workflow_request

        # NOTE: The order is important, first prefix match wins (will be a longer match)
        EVENT_TARGET_TYPES = {
          'ActivityTaskCancel'                     => CANCEL_ACTIVITY_REQUEST_TYPE,
          'ActivityTask'                           => ACTIVITY_TYPE,
          'RequestCancelActivityTask'              => CANCEL_ACTIVITY_REQUEST_TYPE,
          'TimerCanceled'                          => CANCEL_TIMER_REQUEST_TYPE,
          'Timer'                                  => TIMER_TYPE,
          'CancelTimer'                            => CANCEL_TIMER_REQUEST_TYPE,
          'ChildWorkflowExecution'                 => CHILD_WORKFLOW_TYPE,
          'StartChildWorkflowExecution'            => CHILD_WORKFLOW_TYPE,
          'Marker'                                 => MARKER_TYPE,
          'ExternalWorkflowExecution'              => EXTERNAL_WORKFLOW_TYPE,
          'SignalExternalWorkflowExecution'        => EXTERNAL_WORKFLOW_TYPE,
          'ExternalWorkflowExecutionCancel'        => CANCEL_EXTERNAL_WORKFLOW_REQUEST_TYPE,
          'RequestCancelExternalWorkflowExecution' => CANCEL_EXTERNAL_WORKFLOW_REQUEST_TYPE,
          'UpsertWorkflowSearchAttributes'         => WORKFLOW_TYPE,
          'WorkflowExecutionCancel'                => CANCEL_WORKFLOW_REQUEST_TYPE,
          'WorkflowExecution'                      => WORKFLOW_TYPE,
        }.freeze

        DECISION_TARGET_TYPES = {
          'Cadence::Workflow::Decision::ScheduleActivity'            => History::EventTarget::ACTIVITY_TYPE,
          'Cadence::Workflow::Decision::RequestActivityCancellation' => History::EventTarget::CANCEL_ACTIVITY_REQUEST_TYPE,
          'Cadence::Workflow::Decision::RecordMarker'                => History::EventTarget::MARKER_TYPE,
          'Cadence::Workflow::Decision::StartTimer'                  => History::EventTarget::TIMER_TYPE,
          'Cadence::Workflow::Decision::CancelTimer'                 => History::EventTarget::CANCEL_TIMER_REQUEST_TYPE,
          'Cadence::Workflow::Decision::CompleteWorkflow'            => History::EventTarget::WORKFLOW_TYPE,
          'Cadence::Workflow::Decision::FailWorkflow'                => History::EventTarget::WORKFLOW_TYPE,
          'Cadence::Workflow::Decision::StartChildWorkflow'          => History::EventTarget::CHILD_WORKFLOW_TYPE,
        }.freeze

        DECISION_ATTRIBUTE_LISTS = {
          'Cadence::Workflow::Decision::ScheduleActivity'            => [:activity_id, :activity_type, :input],
        }

        attr_reader :id, :type, :attributes

        def self.workflow
          @workflow ||= new(1, WORKFLOW_TYPE)
        end

        def self.from_event(event)
          _, target_type = EVENT_TARGET_TYPES.find { |type, _| event.type.start_with?(type) }

          unless target_type
            raise UnexpectedEventType, "Unexpected event #{event.type}"
          end

          new(event.decision_id, target_type, attributes: event.target_attributes)
        end

        def self.from_decision(decision_id, decision)
          decision_type = decision.class.name
          target_type = DECISION_TARGET_TYPES[decision_type]

          unless target_type
            raise UnexpectedDecisionType, "Unexpected decision type #{decision_type}"
          end

          attribute_list = DECISION_ATTRIBUTE_LISTS.fetch(decision_type, [])

          new(decision_id, target_type, attributes: decision.to_h.slice(*attribute_list))
        end

        def initialize(id, type, attributes: {})
          @id = id
          @type = type
          @attributes = attributes

          freeze
        end

        def ==(other)
          id == other.id && type == other.type && attributes == other.attributes
        end

        def eql?(other)
          self == other
        end

        def hash
          [id, type, attributes].hash
        end

        def to_s
          "#{type}: #{id} (#{attributes})"
        end
      end
    end
  end
end
