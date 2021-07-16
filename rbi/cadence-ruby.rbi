module Cadence
  def self.complete_activity(*args, &block); end
  def self.config; end
  def self.configuration; end
  def self.configure(&block); end
  def self.default_client; end
  def self.fail_activity(*args, &block); end
  def self.fetch_workflow_execution_info(*args, &block); end
  def self.get_workflow_history(*args, &block); end
  def self.logger; end
  def self.metrics; end
  def self.register_domain(*args, &block); end
  def self.reset_workflow(*args, &block); end
  def self.schedule_workflow(*args, &block); end
  def self.signal_workflow(*args, &block); end
  def self.start_workflow(*args, &block); end
  def self.terminate_workflow(*args, &block); end
  extend SingleForwardable
end
module Cadence::MetricsAdapters
end
class Cadence::MetricsAdapters::Null
  def count(_key, _count, _tags); end
  def gauge(_key, _value, _tags); end
  def timing(_key, _time, _tags); end
end
class Cadence::Configuration
  def connection_type; end
  def connection_type=(arg0); end
  def default_execution_options; end
  def domain; end
  def domain=(arg0); end
  def for_connection; end
  def headers; end
  def headers=(arg0); end
  def host; end
  def host=(arg0); end
  def initialize; end
  def logger; end
  def logger=(arg0); end
  def metrics_adapter; end
  def metrics_adapter=(arg0); end
  def port; end
  def port=(arg0); end
  def task_list; end
  def task_list=(arg0); end
  def timeouts; end
  def timeouts=(new_timeouts); end
end
class Cadence::Configuration::Connection < Struct
  def host; end
  def host=(_); end
  def port; end
  def port=(_); end
  def self.[](*arg0); end
  def self.inspect; end
  def self.members; end
  def self.new(*arg0); end
  def type; end
  def type=(_); end
end
class Cadence::Configuration::Execution < Struct
  def domain; end
  def domain=(_); end
  def headers; end
  def headers=(_); end
  def self.[](*arg0); end
  def self.inspect; end
  def self.members; end
  def self.new(*arg0); end
  def task_list; end
  def task_list=(_); end
  def timeouts; end
  def timeouts=(_); end
end
module Cadence::Concerns
end
module Cadence::Concerns::Executable
  def domain(*args); end
  def headers(*args); end
  def retry_policy(*args); end
  def task_list(*args); end
  def timeouts(*args); end
end
class Cadence::Error < StandardError
end
class Cadence::InternalError < Cadence::Error
end
class Cadence::NonDeterministicWorkflowError < Cadence::InternalError
end
class Cadence::ClientError < Cadence::Error
end
class Cadence::TimeoutError < Cadence::ClientError
end
class Cadence::ActivityException < Cadence::ClientError
end
class Anonymous_Struct_608 < Struct
  def backoff; end
  def backoff=(_); end
  def expiration_interval; end
  def expiration_interval=(_); end
  def interval; end
  def interval=(_); end
  def max_attempts; end
  def max_attempts=(_); end
  def max_interval; end
  def max_interval=(_); end
  def non_retriable_errors; end
  def non_retriable_errors=(_); end
  def self.[](*arg0); end
  def self.inspect; end
  def self.members; end
  def self.new(*arg0); end
end
class Cadence::RetryPolicy < Anonymous_Struct_608
  def validate!; end
end
class Cadence::RetryPolicy::InvalidRetryPolicy < Cadence::ClientError
end
class Cadence::ExecutionOptions
  def domain; end
  def headers; end
  def initialize(object, options, defaults = nil); end
  def name; end
  def retry_policy; end
  def task_list; end
  def timeouts; end
end
module Cadence::JSON
  def self.deserialize(value); end
  def self.serialize(value); end
end
module Cadence::Connection
  def self.generate(configuration, options = nil); end
end
class Cadence::Connection::Error < StandardError
end
class Cadence::Connection::ArgumentError < Cadence::Connection::Error
end
module CadenceThrift
end
module CadenceThrift::WorkflowIdReusePolicy
end
module CadenceThrift::DomainStatus
end
module CadenceThrift::TimeoutType
end
module CadenceThrift::ParentClosePolicy
end
module CadenceThrift::DecisionType
end
module CadenceThrift::EventType
end
module CadenceThrift::DecisionTaskFailedCause
end
module CadenceThrift::CancelExternalWorkflowExecutionFailedCause
end
module CadenceThrift::SignalExternalWorkflowExecutionFailedCause
end
module CadenceThrift::ChildWorkflowExecutionFailedCause
end
module CadenceThrift::WorkflowExecutionCloseStatus
end
module CadenceThrift::QueryTaskCompletedType
end
module CadenceThrift::QueryResultType
end
module CadenceThrift::PendingActivityState
end
module CadenceThrift::HistoryEventFilterType
end
module CadenceThrift::TaskListKind
end
module CadenceThrift::ArchivalStatus
end
module CadenceThrift::IndexedValueType
end
module CadenceThrift::EncodingType
end
module CadenceThrift::QueryRejectCondition
end
module CadenceThrift::ContinueAsNewInitiator
end
module CadenceThrift::TaskListType
end
class CadenceThrift::BadRequestError < Thrift::Exception
  def initialize(message = nil); end
  def message; end
  def message=(value); end
  def message?; end
  def struct_fields; end
  def struct_initialize(d = nil, &block); end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::InternalServiceError < Thrift::Exception
  def initialize(message = nil); end
  def message; end
  def message=(value); end
  def message?; end
  def struct_fields; end
  def struct_initialize(d = nil, &block); end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::DomainAlreadyExistsError < Thrift::Exception
  def initialize(message = nil); end
  def message; end
  def message=(value); end
  def message?; end
  def struct_fields; end
  def struct_initialize(d = nil, &block); end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::WorkflowExecutionAlreadyStartedError < Thrift::Exception
  def initialize(*args, &block); end
  def message; end
  def message=(value); end
  def message?; end
  def runId; end
  def runId=(value); end
  def runId?; end
  def startRequestId; end
  def startRequestId=(value); end
  def startRequestId?; end
  def struct_fields; end
  def struct_initialize(d = nil, &block); end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::EntityNotExistsError < Thrift::Exception
  def initialize(message = nil); end
  def message; end
  def message=(value); end
  def message?; end
  def struct_fields; end
  def struct_initialize(d = nil, &block); end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::ServiceBusyError < Thrift::Exception
  def initialize(message = nil); end
  def message; end
  def message=(value); end
  def message?; end
  def struct_fields; end
  def struct_initialize(d = nil, &block); end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::CancellationAlreadyRequestedError < Thrift::Exception
  def initialize(message = nil); end
  def message; end
  def message=(value); end
  def message?; end
  def struct_fields; end
  def struct_initialize(d = nil, &block); end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::QueryFailedError < Thrift::Exception
  def initialize(message = nil); end
  def message; end
  def message=(value); end
  def message?; end
  def struct_fields; end
  def struct_initialize(d = nil, &block); end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::DomainNotActiveError < Thrift::Exception
  def activeCluster; end
  def activeCluster=(value); end
  def activeCluster?; end
  def currentCluster; end
  def currentCluster=(value); end
  def currentCluster?; end
  def domainName; end
  def domainName=(value); end
  def domainName?; end
  def initialize(*args, &block); end
  def message; end
  def message=(value); end
  def message?; end
  def struct_fields; end
  def struct_initialize(d = nil, &block); end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::LimitExceededError < Thrift::Exception
  def initialize(message = nil); end
  def message; end
  def message=(value); end
  def message?; end
  def struct_fields; end
  def struct_initialize(d = nil, &block); end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::AccessDeniedError < Thrift::Exception
  def initialize(message = nil); end
  def message; end
  def message=(value); end
  def message?; end
  def struct_fields; end
  def struct_initialize(d = nil, &block); end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::RetryTaskError < Thrift::Exception
  def domainId; end
  def domainId=(value); end
  def domainId?; end
  def initialize(*args, &block); end
  def message; end
  def message=(value); end
  def message?; end
  def nextEventId; end
  def nextEventId=(value); end
  def nextEventId?; end
  def runId; end
  def runId=(value); end
  def runId?; end
  def struct_fields; end
  def struct_initialize(d = nil, &block); end
  def validate; end
  def workflowId; end
  def workflowId=(value); end
  def workflowId?; end
  include Thrift::Struct
end
class CadenceThrift::ClientVersionNotSupportedError < Thrift::Exception
  def clientImpl; end
  def clientImpl=(value); end
  def clientImpl?; end
  def featureVersion; end
  def featureVersion=(value); end
  def featureVersion?; end
  def initialize(*args, &block); end
  def struct_fields; end
  def struct_initialize(d = nil, &block); end
  def supportedVersions; end
  def supportedVersions=(value); end
  def supportedVersions?; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::Header
  def fields; end
  def fields=(value); end
  def fields?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::WorkflowType
  def name; end
  def name=(value); end
  def name?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::ActivityType
  def name; end
  def name=(value); end
  def name?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::TaskList
  def kind; end
  def kind=(value); end
  def kind?; end
  def name; end
  def name=(value); end
  def name?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::DataBlob
  def Data; end
  def Data=(value); end
  def Data?; end
  def EncodingType; end
  def EncodingType=(value); end
  def EncodingType?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::ReplicationInfo
  def lastEventId; end
  def lastEventId=(value); end
  def lastEventId?; end
  def struct_fields; end
  def validate; end
  def version; end
  def version=(value); end
  def version?; end
  include Thrift::Struct
end
class CadenceThrift::TaskListMetadata
  def maxTasksPerSecond; end
  def maxTasksPerSecond=(value); end
  def maxTasksPerSecond?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::WorkflowExecution
  def runId; end
  def runId=(value); end
  def runId?; end
  def struct_fields; end
  def validate; end
  def workflowId; end
  def workflowId=(value); end
  def workflowId?; end
  include Thrift::Struct
end
class CadenceThrift::Memo
  def fields; end
  def fields=(value); end
  def fields?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::SearchAttributes
  def indexedFields; end
  def indexedFields=(value); end
  def indexedFields?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::WorkflowExecutionInfo
  def autoResetPoints; end
  def autoResetPoints=(value); end
  def autoResetPoints?; end
  def closeStatus; end
  def closeStatus=(value); end
  def closeStatus?; end
  def closeTime; end
  def closeTime=(value); end
  def closeTime?; end
  def execution; end
  def execution=(value); end
  def execution?; end
  def executionTime; end
  def executionTime=(value); end
  def executionTime?; end
  def historyLength; end
  def historyLength=(value); end
  def historyLength?; end
  def memo; end
  def memo=(value); end
  def memo?; end
  def parentDomainId; end
  def parentDomainId=(value); end
  def parentDomainId?; end
  def parentExecution; end
  def parentExecution=(value); end
  def parentExecution?; end
  def searchAttributes; end
  def searchAttributes=(value); end
  def searchAttributes?; end
  def startTime; end
  def startTime=(value); end
  def startTime?; end
  def struct_fields; end
  def type; end
  def type=(value); end
  def type?; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::WorkflowExecutionConfiguration
  def executionStartToCloseTimeoutSeconds; end
  def executionStartToCloseTimeoutSeconds=(value); end
  def executionStartToCloseTimeoutSeconds?; end
  def struct_fields; end
  def taskList; end
  def taskList=(value); end
  def taskList?; end
  def taskStartToCloseTimeoutSeconds; end
  def taskStartToCloseTimeoutSeconds=(value); end
  def taskStartToCloseTimeoutSeconds?; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::TransientDecisionInfo
  def scheduledEvent; end
  def scheduledEvent=(value); end
  def scheduledEvent?; end
  def startedEvent; end
  def startedEvent=(value); end
  def startedEvent?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::ScheduleActivityTaskDecisionAttributes
  def activityId; end
  def activityId=(value); end
  def activityId?; end
  def activityType; end
  def activityType=(value); end
  def activityType?; end
  def domain; end
  def domain=(value); end
  def domain?; end
  def header; end
  def header=(value); end
  def header?; end
  def heartbeatTimeoutSeconds; end
  def heartbeatTimeoutSeconds=(value); end
  def heartbeatTimeoutSeconds?; end
  def input; end
  def input=(value); end
  def input?; end
  def retryPolicy; end
  def retryPolicy=(value); end
  def retryPolicy?; end
  def scheduleToCloseTimeoutSeconds; end
  def scheduleToCloseTimeoutSeconds=(value); end
  def scheduleToCloseTimeoutSeconds?; end
  def scheduleToStartTimeoutSeconds; end
  def scheduleToStartTimeoutSeconds=(value); end
  def scheduleToStartTimeoutSeconds?; end
  def startToCloseTimeoutSeconds; end
  def startToCloseTimeoutSeconds=(value); end
  def startToCloseTimeoutSeconds?; end
  def struct_fields; end
  def taskList; end
  def taskList=(value); end
  def taskList?; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::RequestCancelActivityTaskDecisionAttributes
  def activityId; end
  def activityId=(value); end
  def activityId?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::StartTimerDecisionAttributes
  def startToFireTimeoutSeconds; end
  def startToFireTimeoutSeconds=(value); end
  def startToFireTimeoutSeconds?; end
  def struct_fields; end
  def timerId; end
  def timerId=(value); end
  def timerId?; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::CompleteWorkflowExecutionDecisionAttributes
  def result; end
  def result=(value); end
  def result?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::FailWorkflowExecutionDecisionAttributes
  def details; end
  def details=(value); end
  def details?; end
  def reason; end
  def reason=(value); end
  def reason?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::CancelTimerDecisionAttributes
  def struct_fields; end
  def timerId; end
  def timerId=(value); end
  def timerId?; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::CancelWorkflowExecutionDecisionAttributes
  def details; end
  def details=(value); end
  def details?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::RequestCancelExternalWorkflowExecutionDecisionAttributes
  def childWorkflowOnly; end
  def childWorkflowOnly=(value); end
  def childWorkflowOnly?; end
  def control; end
  def control=(value); end
  def control?; end
  def domain; end
  def domain=(value); end
  def domain?; end
  def runId; end
  def runId=(value); end
  def runId?; end
  def struct_fields; end
  def validate; end
  def workflowId; end
  def workflowId=(value); end
  def workflowId?; end
  include Thrift::Struct
end
class CadenceThrift::SignalExternalWorkflowExecutionDecisionAttributes
  def childWorkflowOnly; end
  def childWorkflowOnly=(value); end
  def childWorkflowOnly?; end
  def control; end
  def control=(value); end
  def control?; end
  def domain; end
  def domain=(value); end
  def domain?; end
  def execution; end
  def execution=(value); end
  def execution?; end
  def input; end
  def input=(value); end
  def input?; end
  def signalName; end
  def signalName=(value); end
  def signalName?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::UpsertWorkflowSearchAttributesDecisionAttributes
  def searchAttributes; end
  def searchAttributes=(value); end
  def searchAttributes?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::RecordMarkerDecisionAttributes
  def details; end
  def details=(value); end
  def details?; end
  def header; end
  def header=(value); end
  def header?; end
  def markerName; end
  def markerName=(value); end
  def markerName?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::ContinueAsNewWorkflowExecutionDecisionAttributes
  def backoffStartIntervalInSeconds; end
  def backoffStartIntervalInSeconds=(value); end
  def backoffStartIntervalInSeconds?; end
  def cronSchedule; end
  def cronSchedule=(value); end
  def cronSchedule?; end
  def executionStartToCloseTimeoutSeconds; end
  def executionStartToCloseTimeoutSeconds=(value); end
  def executionStartToCloseTimeoutSeconds?; end
  def failureDetails; end
  def failureDetails=(value); end
  def failureDetails?; end
  def failureReason; end
  def failureReason=(value); end
  def failureReason?; end
  def header; end
  def header=(value); end
  def header?; end
  def initiator; end
  def initiator=(value); end
  def initiator?; end
  def input; end
  def input=(value); end
  def input?; end
  def lastCompletionResult; end
  def lastCompletionResult=(value); end
  def lastCompletionResult?; end
  def memo; end
  def memo=(value); end
  def memo?; end
  def retryPolicy; end
  def retryPolicy=(value); end
  def retryPolicy?; end
  def searchAttributes; end
  def searchAttributes=(value); end
  def searchAttributes?; end
  def struct_fields; end
  def taskList; end
  def taskList=(value); end
  def taskList?; end
  def taskStartToCloseTimeoutSeconds; end
  def taskStartToCloseTimeoutSeconds=(value); end
  def taskStartToCloseTimeoutSeconds?; end
  def validate; end
  def workflowType; end
  def workflowType=(value); end
  def workflowType?; end
  include Thrift::Struct
end
class CadenceThrift::StartChildWorkflowExecutionDecisionAttributes
  def control; end
  def control=(value); end
  def control?; end
  def cronSchedule; end
  def cronSchedule=(value); end
  def cronSchedule?; end
  def domain; end
  def domain=(value); end
  def domain?; end
  def executionStartToCloseTimeoutSeconds; end
  def executionStartToCloseTimeoutSeconds=(value); end
  def executionStartToCloseTimeoutSeconds?; end
  def header; end
  def header=(value); end
  def header?; end
  def input; end
  def input=(value); end
  def input?; end
  def memo; end
  def memo=(value); end
  def memo?; end
  def parentClosePolicy; end
  def parentClosePolicy=(value); end
  def parentClosePolicy?; end
  def retryPolicy; end
  def retryPolicy=(value); end
  def retryPolicy?; end
  def searchAttributes; end
  def searchAttributes=(value); end
  def searchAttributes?; end
  def struct_fields; end
  def taskList; end
  def taskList=(value); end
  def taskList?; end
  def taskStartToCloseTimeoutSeconds; end
  def taskStartToCloseTimeoutSeconds=(value); end
  def taskStartToCloseTimeoutSeconds?; end
  def validate; end
  def workflowId; end
  def workflowId=(value); end
  def workflowId?; end
  def workflowIdReusePolicy; end
  def workflowIdReusePolicy=(value); end
  def workflowIdReusePolicy?; end
  def workflowType; end
  def workflowType=(value); end
  def workflowType?; end
  include Thrift::Struct
end
class CadenceThrift::Decision
  def cancelTimerDecisionAttributes; end
  def cancelTimerDecisionAttributes=(value); end
  def cancelTimerDecisionAttributes?; end
  def cancelWorkflowExecutionDecisionAttributes; end
  def cancelWorkflowExecutionDecisionAttributes=(value); end
  def cancelWorkflowExecutionDecisionAttributes?; end
  def completeWorkflowExecutionDecisionAttributes; end
  def completeWorkflowExecutionDecisionAttributes=(value); end
  def completeWorkflowExecutionDecisionAttributes?; end
  def continueAsNewWorkflowExecutionDecisionAttributes; end
  def continueAsNewWorkflowExecutionDecisionAttributes=(value); end
  def continueAsNewWorkflowExecutionDecisionAttributes?; end
  def decisionType; end
  def decisionType=(value); end
  def decisionType?; end
  def failWorkflowExecutionDecisionAttributes; end
  def failWorkflowExecutionDecisionAttributes=(value); end
  def failWorkflowExecutionDecisionAttributes?; end
  def recordMarkerDecisionAttributes; end
  def recordMarkerDecisionAttributes=(value); end
  def recordMarkerDecisionAttributes?; end
  def requestCancelActivityTaskDecisionAttributes; end
  def requestCancelActivityTaskDecisionAttributes=(value); end
  def requestCancelActivityTaskDecisionAttributes?; end
  def requestCancelExternalWorkflowExecutionDecisionAttributes; end
  def requestCancelExternalWorkflowExecutionDecisionAttributes=(value); end
  def requestCancelExternalWorkflowExecutionDecisionAttributes?; end
  def scheduleActivityTaskDecisionAttributes; end
  def scheduleActivityTaskDecisionAttributes=(value); end
  def scheduleActivityTaskDecisionAttributes?; end
  def signalExternalWorkflowExecutionDecisionAttributes; end
  def signalExternalWorkflowExecutionDecisionAttributes=(value); end
  def signalExternalWorkflowExecutionDecisionAttributes?; end
  def startChildWorkflowExecutionDecisionAttributes; end
  def startChildWorkflowExecutionDecisionAttributes=(value); end
  def startChildWorkflowExecutionDecisionAttributes?; end
  def startTimerDecisionAttributes; end
  def startTimerDecisionAttributes=(value); end
  def startTimerDecisionAttributes?; end
  def struct_fields; end
  def upsertWorkflowSearchAttributesDecisionAttributes; end
  def upsertWorkflowSearchAttributesDecisionAttributes=(value); end
  def upsertWorkflowSearchAttributesDecisionAttributes?; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::WorkflowExecutionStartedEventAttributes
  def attempt; end
  def attempt=(value); end
  def attempt?; end
  def continuedExecutionRunId; end
  def continuedExecutionRunId=(value); end
  def continuedExecutionRunId?; end
  def continuedFailureDetails; end
  def continuedFailureDetails=(value); end
  def continuedFailureDetails?; end
  def continuedFailureReason; end
  def continuedFailureReason=(value); end
  def continuedFailureReason?; end
  def cronSchedule; end
  def cronSchedule=(value); end
  def cronSchedule?; end
  def executionStartToCloseTimeoutSeconds; end
  def executionStartToCloseTimeoutSeconds=(value); end
  def executionStartToCloseTimeoutSeconds?; end
  def expirationTimestamp; end
  def expirationTimestamp=(value); end
  def expirationTimestamp?; end
  def firstDecisionTaskBackoffSeconds; end
  def firstDecisionTaskBackoffSeconds=(value); end
  def firstDecisionTaskBackoffSeconds?; end
  def firstExecutionRunId; end
  def firstExecutionRunId=(value); end
  def firstExecutionRunId?; end
  def header; end
  def header=(value); end
  def header?; end
  def identity; end
  def identity=(value); end
  def identity?; end
  def initiator; end
  def initiator=(value); end
  def initiator?; end
  def input; end
  def input=(value); end
  def input?; end
  def lastCompletionResult; end
  def lastCompletionResult=(value); end
  def lastCompletionResult?; end
  def memo; end
  def memo=(value); end
  def memo?; end
  def originalExecutionRunId; end
  def originalExecutionRunId=(value); end
  def originalExecutionRunId?; end
  def parentInitiatedEventId; end
  def parentInitiatedEventId=(value); end
  def parentInitiatedEventId?; end
  def parentWorkflowDomain; end
  def parentWorkflowDomain=(value); end
  def parentWorkflowDomain?; end
  def parentWorkflowExecution; end
  def parentWorkflowExecution=(value); end
  def parentWorkflowExecution?; end
  def prevAutoResetPoints; end
  def prevAutoResetPoints=(value); end
  def prevAutoResetPoints?; end
  def retryPolicy; end
  def retryPolicy=(value); end
  def retryPolicy?; end
  def searchAttributes; end
  def searchAttributes=(value); end
  def searchAttributes?; end
  def struct_fields; end
  def taskList; end
  def taskList=(value); end
  def taskList?; end
  def taskStartToCloseTimeoutSeconds; end
  def taskStartToCloseTimeoutSeconds=(value); end
  def taskStartToCloseTimeoutSeconds?; end
  def validate; end
  def workflowType; end
  def workflowType=(value); end
  def workflowType?; end
  include Thrift::Struct
end
class CadenceThrift::ResetPoints
  def points; end
  def points=(value); end
  def points?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::ResetPointInfo
  def binaryChecksum; end
  def binaryChecksum=(value); end
  def binaryChecksum?; end
  def createdTimeNano; end
  def createdTimeNano=(value); end
  def createdTimeNano?; end
  def expiringTimeNano; end
  def expiringTimeNano=(value); end
  def expiringTimeNano?; end
  def firstDecisionCompletedId; end
  def firstDecisionCompletedId=(value); end
  def firstDecisionCompletedId?; end
  def resettable; end
  def resettable=(value); end
  def resettable?; end
  def runId; end
  def runId=(value); end
  def runId?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::WorkflowExecutionCompletedEventAttributes
  def decisionTaskCompletedEventId; end
  def decisionTaskCompletedEventId=(value); end
  def decisionTaskCompletedEventId?; end
  def result; end
  def result=(value); end
  def result?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::WorkflowExecutionFailedEventAttributes
  def decisionTaskCompletedEventId; end
  def decisionTaskCompletedEventId=(value); end
  def decisionTaskCompletedEventId?; end
  def details; end
  def details=(value); end
  def details?; end
  def reason; end
  def reason=(value); end
  def reason?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::WorkflowExecutionTimedOutEventAttributes
  def struct_fields; end
  def timeoutType; end
  def timeoutType=(value); end
  def timeoutType?; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::WorkflowExecutionContinuedAsNewEventAttributes
  def backoffStartIntervalInSeconds; end
  def backoffStartIntervalInSeconds=(value); end
  def backoffStartIntervalInSeconds?; end
  def decisionTaskCompletedEventId; end
  def decisionTaskCompletedEventId=(value); end
  def decisionTaskCompletedEventId?; end
  def executionStartToCloseTimeoutSeconds; end
  def executionStartToCloseTimeoutSeconds=(value); end
  def executionStartToCloseTimeoutSeconds?; end
  def failureDetails; end
  def failureDetails=(value); end
  def failureDetails?; end
  def failureReason; end
  def failureReason=(value); end
  def failureReason?; end
  def header; end
  def header=(value); end
  def header?; end
  def initiator; end
  def initiator=(value); end
  def initiator?; end
  def input; end
  def input=(value); end
  def input?; end
  def lastCompletionResult; end
  def lastCompletionResult=(value); end
  def lastCompletionResult?; end
  def memo; end
  def memo=(value); end
  def memo?; end
  def newExecutionRunId; end
  def newExecutionRunId=(value); end
  def newExecutionRunId?; end
  def searchAttributes; end
  def searchAttributes=(value); end
  def searchAttributes?; end
  def struct_fields; end
  def taskList; end
  def taskList=(value); end
  def taskList?; end
  def taskStartToCloseTimeoutSeconds; end
  def taskStartToCloseTimeoutSeconds=(value); end
  def taskStartToCloseTimeoutSeconds?; end
  def validate; end
  def workflowType; end
  def workflowType=(value); end
  def workflowType?; end
  include Thrift::Struct
end
class CadenceThrift::DecisionTaskScheduledEventAttributes
  def attempt; end
  def attempt=(value); end
  def attempt?; end
  def startToCloseTimeoutSeconds; end
  def startToCloseTimeoutSeconds=(value); end
  def startToCloseTimeoutSeconds?; end
  def struct_fields; end
  def taskList; end
  def taskList=(value); end
  def taskList?; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::DecisionTaskStartedEventAttributes
  def identity; end
  def identity=(value); end
  def identity?; end
  def requestId; end
  def requestId=(value); end
  def requestId?; end
  def scheduledEventId; end
  def scheduledEventId=(value); end
  def scheduledEventId?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::DecisionTaskCompletedEventAttributes
  def binaryChecksum; end
  def binaryChecksum=(value); end
  def binaryChecksum?; end
  def executionContext; end
  def executionContext=(value); end
  def executionContext?; end
  def identity; end
  def identity=(value); end
  def identity?; end
  def scheduledEventId; end
  def scheduledEventId=(value); end
  def scheduledEventId?; end
  def startedEventId; end
  def startedEventId=(value); end
  def startedEventId?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::DecisionTaskTimedOutEventAttributes
  def scheduledEventId; end
  def scheduledEventId=(value); end
  def scheduledEventId?; end
  def startedEventId; end
  def startedEventId=(value); end
  def startedEventId?; end
  def struct_fields; end
  def timeoutType; end
  def timeoutType=(value); end
  def timeoutType?; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::DecisionTaskFailedEventAttributes
  def baseRunId; end
  def baseRunId=(value); end
  def baseRunId?; end
  def cause; end
  def cause=(value); end
  def cause?; end
  def details; end
  def details=(value); end
  def details?; end
  def forkEventVersion; end
  def forkEventVersion=(value); end
  def forkEventVersion?; end
  def identity; end
  def identity=(value); end
  def identity?; end
  def newRunId; end
  def newRunId=(value); end
  def newRunId?; end
  def reason; end
  def reason=(value); end
  def reason?; end
  def scheduledEventId; end
  def scheduledEventId=(value); end
  def scheduledEventId?; end
  def startedEventId; end
  def startedEventId=(value); end
  def startedEventId?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::ActivityTaskScheduledEventAttributes
  def activityId; end
  def activityId=(value); end
  def activityId?; end
  def activityType; end
  def activityType=(value); end
  def activityType?; end
  def decisionTaskCompletedEventId; end
  def decisionTaskCompletedEventId=(value); end
  def decisionTaskCompletedEventId?; end
  def domain; end
  def domain=(value); end
  def domain?; end
  def header; end
  def header=(value); end
  def header?; end
  def heartbeatTimeoutSeconds; end
  def heartbeatTimeoutSeconds=(value); end
  def heartbeatTimeoutSeconds?; end
  def input; end
  def input=(value); end
  def input?; end
  def retryPolicy; end
  def retryPolicy=(value); end
  def retryPolicy?; end
  def scheduleToCloseTimeoutSeconds; end
  def scheduleToCloseTimeoutSeconds=(value); end
  def scheduleToCloseTimeoutSeconds?; end
  def scheduleToStartTimeoutSeconds; end
  def scheduleToStartTimeoutSeconds=(value); end
  def scheduleToStartTimeoutSeconds?; end
  def startToCloseTimeoutSeconds; end
  def startToCloseTimeoutSeconds=(value); end
  def startToCloseTimeoutSeconds?; end
  def struct_fields; end
  def taskList; end
  def taskList=(value); end
  def taskList?; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::ActivityTaskStartedEventAttributes
  def attempt; end
  def attempt=(value); end
  def attempt?; end
  def identity; end
  def identity=(value); end
  def identity?; end
  def requestId; end
  def requestId=(value); end
  def requestId?; end
  def scheduledEventId; end
  def scheduledEventId=(value); end
  def scheduledEventId?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::ActivityTaskCompletedEventAttributes
  def identity; end
  def identity=(value); end
  def identity?; end
  def result; end
  def result=(value); end
  def result?; end
  def scheduledEventId; end
  def scheduledEventId=(value); end
  def scheduledEventId?; end
  def startedEventId; end
  def startedEventId=(value); end
  def startedEventId?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::ActivityTaskFailedEventAttributes
  def details; end
  def details=(value); end
  def details?; end
  def identity; end
  def identity=(value); end
  def identity?; end
  def reason; end
  def reason=(value); end
  def reason?; end
  def scheduledEventId; end
  def scheduledEventId=(value); end
  def scheduledEventId?; end
  def startedEventId; end
  def startedEventId=(value); end
  def startedEventId?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::ActivityTaskTimedOutEventAttributes
  def details; end
  def details=(value); end
  def details?; end
  def scheduledEventId; end
  def scheduledEventId=(value); end
  def scheduledEventId?; end
  def startedEventId; end
  def startedEventId=(value); end
  def startedEventId?; end
  def struct_fields; end
  def timeoutType; end
  def timeoutType=(value); end
  def timeoutType?; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::ActivityTaskCancelRequestedEventAttributes
  def activityId; end
  def activityId=(value); end
  def activityId?; end
  def decisionTaskCompletedEventId; end
  def decisionTaskCompletedEventId=(value); end
  def decisionTaskCompletedEventId?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::RequestCancelActivityTaskFailedEventAttributes
  def activityId; end
  def activityId=(value); end
  def activityId?; end
  def cause; end
  def cause=(value); end
  def cause?; end
  def decisionTaskCompletedEventId; end
  def decisionTaskCompletedEventId=(value); end
  def decisionTaskCompletedEventId?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::ActivityTaskCanceledEventAttributes
  def details; end
  def details=(value); end
  def details?; end
  def identity; end
  def identity=(value); end
  def identity?; end
  def latestCancelRequestedEventId; end
  def latestCancelRequestedEventId=(value); end
  def latestCancelRequestedEventId?; end
  def scheduledEventId; end
  def scheduledEventId=(value); end
  def scheduledEventId?; end
  def startedEventId; end
  def startedEventId=(value); end
  def startedEventId?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::TimerStartedEventAttributes
  def decisionTaskCompletedEventId; end
  def decisionTaskCompletedEventId=(value); end
  def decisionTaskCompletedEventId?; end
  def startToFireTimeoutSeconds; end
  def startToFireTimeoutSeconds=(value); end
  def startToFireTimeoutSeconds?; end
  def struct_fields; end
  def timerId; end
  def timerId=(value); end
  def timerId?; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::TimerFiredEventAttributes
  def startedEventId; end
  def startedEventId=(value); end
  def startedEventId?; end
  def struct_fields; end
  def timerId; end
  def timerId=(value); end
  def timerId?; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::TimerCanceledEventAttributes
  def decisionTaskCompletedEventId; end
  def decisionTaskCompletedEventId=(value); end
  def decisionTaskCompletedEventId?; end
  def identity; end
  def identity=(value); end
  def identity?; end
  def startedEventId; end
  def startedEventId=(value); end
  def startedEventId?; end
  def struct_fields; end
  def timerId; end
  def timerId=(value); end
  def timerId?; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::CancelTimerFailedEventAttributes
  def cause; end
  def cause=(value); end
  def cause?; end
  def decisionTaskCompletedEventId; end
  def decisionTaskCompletedEventId=(value); end
  def decisionTaskCompletedEventId?; end
  def identity; end
  def identity=(value); end
  def identity?; end
  def struct_fields; end
  def timerId; end
  def timerId=(value); end
  def timerId?; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::WorkflowExecutionCancelRequestedEventAttributes
  def cause; end
  def cause=(value); end
  def cause?; end
  def externalInitiatedEventId; end
  def externalInitiatedEventId=(value); end
  def externalInitiatedEventId?; end
  def externalWorkflowExecution; end
  def externalWorkflowExecution=(value); end
  def externalWorkflowExecution?; end
  def identity; end
  def identity=(value); end
  def identity?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::WorkflowExecutionCanceledEventAttributes
  def decisionTaskCompletedEventId; end
  def decisionTaskCompletedEventId=(value); end
  def decisionTaskCompletedEventId?; end
  def details; end
  def details=(value); end
  def details?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::MarkerRecordedEventAttributes
  def decisionTaskCompletedEventId; end
  def decisionTaskCompletedEventId=(value); end
  def decisionTaskCompletedEventId?; end
  def details; end
  def details=(value); end
  def details?; end
  def header; end
  def header=(value); end
  def header?; end
  def markerName; end
  def markerName=(value); end
  def markerName?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::WorkflowExecutionSignaledEventAttributes
  def identity; end
  def identity=(value); end
  def identity?; end
  def input; end
  def input=(value); end
  def input?; end
  def signalName; end
  def signalName=(value); end
  def signalName?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::WorkflowExecutionTerminatedEventAttributes
  def details; end
  def details=(value); end
  def details?; end
  def identity; end
  def identity=(value); end
  def identity?; end
  def reason; end
  def reason=(value); end
  def reason?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::RequestCancelExternalWorkflowExecutionInitiatedEventAttributes
  def childWorkflowOnly; end
  def childWorkflowOnly=(value); end
  def childWorkflowOnly?; end
  def control; end
  def control=(value); end
  def control?; end
  def decisionTaskCompletedEventId; end
  def decisionTaskCompletedEventId=(value); end
  def decisionTaskCompletedEventId?; end
  def domain; end
  def domain=(value); end
  def domain?; end
  def struct_fields; end
  def validate; end
  def workflowExecution; end
  def workflowExecution=(value); end
  def workflowExecution?; end
  include Thrift::Struct
end
class CadenceThrift::RequestCancelExternalWorkflowExecutionFailedEventAttributes
  def cause; end
  def cause=(value); end
  def cause?; end
  def control; end
  def control=(value); end
  def control?; end
  def decisionTaskCompletedEventId; end
  def decisionTaskCompletedEventId=(value); end
  def decisionTaskCompletedEventId?; end
  def domain; end
  def domain=(value); end
  def domain?; end
  def initiatedEventId; end
  def initiatedEventId=(value); end
  def initiatedEventId?; end
  def struct_fields; end
  def validate; end
  def workflowExecution; end
  def workflowExecution=(value); end
  def workflowExecution?; end
  include Thrift::Struct
end
class CadenceThrift::ExternalWorkflowExecutionCancelRequestedEventAttributes
  def domain; end
  def domain=(value); end
  def domain?; end
  def initiatedEventId; end
  def initiatedEventId=(value); end
  def initiatedEventId?; end
  def struct_fields; end
  def validate; end
  def workflowExecution; end
  def workflowExecution=(value); end
  def workflowExecution?; end
  include Thrift::Struct
end
class CadenceThrift::SignalExternalWorkflowExecutionInitiatedEventAttributes
  def childWorkflowOnly; end
  def childWorkflowOnly=(value); end
  def childWorkflowOnly?; end
  def control; end
  def control=(value); end
  def control?; end
  def decisionTaskCompletedEventId; end
  def decisionTaskCompletedEventId=(value); end
  def decisionTaskCompletedEventId?; end
  def domain; end
  def domain=(value); end
  def domain?; end
  def input; end
  def input=(value); end
  def input?; end
  def signalName; end
  def signalName=(value); end
  def signalName?; end
  def struct_fields; end
  def validate; end
  def workflowExecution; end
  def workflowExecution=(value); end
  def workflowExecution?; end
  include Thrift::Struct
end
class CadenceThrift::SignalExternalWorkflowExecutionFailedEventAttributes
  def cause; end
  def cause=(value); end
  def cause?; end
  def control; end
  def control=(value); end
  def control?; end
  def decisionTaskCompletedEventId; end
  def decisionTaskCompletedEventId=(value); end
  def decisionTaskCompletedEventId?; end
  def domain; end
  def domain=(value); end
  def domain?; end
  def initiatedEventId; end
  def initiatedEventId=(value); end
  def initiatedEventId?; end
  def struct_fields; end
  def validate; end
  def workflowExecution; end
  def workflowExecution=(value); end
  def workflowExecution?; end
  include Thrift::Struct
end
class CadenceThrift::ExternalWorkflowExecutionSignaledEventAttributes
  def control; end
  def control=(value); end
  def control?; end
  def domain; end
  def domain=(value); end
  def domain?; end
  def initiatedEventId; end
  def initiatedEventId=(value); end
  def initiatedEventId?; end
  def struct_fields; end
  def validate; end
  def workflowExecution; end
  def workflowExecution=(value); end
  def workflowExecution?; end
  include Thrift::Struct
end
class CadenceThrift::UpsertWorkflowSearchAttributesEventAttributes
  def decisionTaskCompletedEventId; end
  def decisionTaskCompletedEventId=(value); end
  def decisionTaskCompletedEventId?; end
  def searchAttributes; end
  def searchAttributes=(value); end
  def searchAttributes?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::StartChildWorkflowExecutionInitiatedEventAttributes
  def control; end
  def control=(value); end
  def control?; end
  def cronSchedule; end
  def cronSchedule=(value); end
  def cronSchedule?; end
  def decisionTaskCompletedEventId; end
  def decisionTaskCompletedEventId=(value); end
  def decisionTaskCompletedEventId?; end
  def domain; end
  def domain=(value); end
  def domain?; end
  def executionStartToCloseTimeoutSeconds; end
  def executionStartToCloseTimeoutSeconds=(value); end
  def executionStartToCloseTimeoutSeconds?; end
  def header; end
  def header=(value); end
  def header?; end
  def input; end
  def input=(value); end
  def input?; end
  def memo; end
  def memo=(value); end
  def memo?; end
  def parentClosePolicy; end
  def parentClosePolicy=(value); end
  def parentClosePolicy?; end
  def retryPolicy; end
  def retryPolicy=(value); end
  def retryPolicy?; end
  def searchAttributes; end
  def searchAttributes=(value); end
  def searchAttributes?; end
  def struct_fields; end
  def taskList; end
  def taskList=(value); end
  def taskList?; end
  def taskStartToCloseTimeoutSeconds; end
  def taskStartToCloseTimeoutSeconds=(value); end
  def taskStartToCloseTimeoutSeconds?; end
  def validate; end
  def workflowId; end
  def workflowId=(value); end
  def workflowId?; end
  def workflowIdReusePolicy; end
  def workflowIdReusePolicy=(value); end
  def workflowIdReusePolicy?; end
  def workflowType; end
  def workflowType=(value); end
  def workflowType?; end
  include Thrift::Struct
end
class CadenceThrift::StartChildWorkflowExecutionFailedEventAttributes
  def cause; end
  def cause=(value); end
  def cause?; end
  def control; end
  def control=(value); end
  def control?; end
  def decisionTaskCompletedEventId; end
  def decisionTaskCompletedEventId=(value); end
  def decisionTaskCompletedEventId?; end
  def domain; end
  def domain=(value); end
  def domain?; end
  def initiatedEventId; end
  def initiatedEventId=(value); end
  def initiatedEventId?; end
  def struct_fields; end
  def validate; end
  def workflowId; end
  def workflowId=(value); end
  def workflowId?; end
  def workflowType; end
  def workflowType=(value); end
  def workflowType?; end
  include Thrift::Struct
end
class CadenceThrift::ChildWorkflowExecutionStartedEventAttributes
  def domain; end
  def domain=(value); end
  def domain?; end
  def header; end
  def header=(value); end
  def header?; end
  def initiatedEventId; end
  def initiatedEventId=(value); end
  def initiatedEventId?; end
  def struct_fields; end
  def validate; end
  def workflowExecution; end
  def workflowExecution=(value); end
  def workflowExecution?; end
  def workflowType; end
  def workflowType=(value); end
  def workflowType?; end
  include Thrift::Struct
end
class CadenceThrift::ChildWorkflowExecutionCompletedEventAttributes
  def domain; end
  def domain=(value); end
  def domain?; end
  def initiatedEventId; end
  def initiatedEventId=(value); end
  def initiatedEventId?; end
  def result; end
  def result=(value); end
  def result?; end
  def startedEventId; end
  def startedEventId=(value); end
  def startedEventId?; end
  def struct_fields; end
  def validate; end
  def workflowExecution; end
  def workflowExecution=(value); end
  def workflowExecution?; end
  def workflowType; end
  def workflowType=(value); end
  def workflowType?; end
  include Thrift::Struct
end
class CadenceThrift::ChildWorkflowExecutionFailedEventAttributes
  def details; end
  def details=(value); end
  def details?; end
  def domain; end
  def domain=(value); end
  def domain?; end
  def initiatedEventId; end
  def initiatedEventId=(value); end
  def initiatedEventId?; end
  def reason; end
  def reason=(value); end
  def reason?; end
  def startedEventId; end
  def startedEventId=(value); end
  def startedEventId?; end
  def struct_fields; end
  def validate; end
  def workflowExecution; end
  def workflowExecution=(value); end
  def workflowExecution?; end
  def workflowType; end
  def workflowType=(value); end
  def workflowType?; end
  include Thrift::Struct
end
class CadenceThrift::ChildWorkflowExecutionCanceledEventAttributes
  def details; end
  def details=(value); end
  def details?; end
  def domain; end
  def domain=(value); end
  def domain?; end
  def initiatedEventId; end
  def initiatedEventId=(value); end
  def initiatedEventId?; end
  def startedEventId; end
  def startedEventId=(value); end
  def startedEventId?; end
  def struct_fields; end
  def validate; end
  def workflowExecution; end
  def workflowExecution=(value); end
  def workflowExecution?; end
  def workflowType; end
  def workflowType=(value); end
  def workflowType?; end
  include Thrift::Struct
end
class CadenceThrift::ChildWorkflowExecutionTimedOutEventAttributes
  def domain; end
  def domain=(value); end
  def domain?; end
  def initiatedEventId; end
  def initiatedEventId=(value); end
  def initiatedEventId?; end
  def startedEventId; end
  def startedEventId=(value); end
  def startedEventId?; end
  def struct_fields; end
  def timeoutType; end
  def timeoutType=(value); end
  def timeoutType?; end
  def validate; end
  def workflowExecution; end
  def workflowExecution=(value); end
  def workflowExecution?; end
  def workflowType; end
  def workflowType=(value); end
  def workflowType?; end
  include Thrift::Struct
end
class CadenceThrift::ChildWorkflowExecutionTerminatedEventAttributes
  def domain; end
  def domain=(value); end
  def domain?; end
  def initiatedEventId; end
  def initiatedEventId=(value); end
  def initiatedEventId?; end
  def startedEventId; end
  def startedEventId=(value); end
  def startedEventId?; end
  def struct_fields; end
  def validate; end
  def workflowExecution; end
  def workflowExecution=(value); end
  def workflowExecution?; end
  def workflowType; end
  def workflowType=(value); end
  def workflowType?; end
  include Thrift::Struct
end
class CadenceThrift::HistoryEvent
  def activityTaskCancelRequestedEventAttributes; end
  def activityTaskCancelRequestedEventAttributes=(value); end
  def activityTaskCancelRequestedEventAttributes?; end
  def activityTaskCanceledEventAttributes; end
  def activityTaskCanceledEventAttributes=(value); end
  def activityTaskCanceledEventAttributes?; end
  def activityTaskCompletedEventAttributes; end
  def activityTaskCompletedEventAttributes=(value); end
  def activityTaskCompletedEventAttributes?; end
  def activityTaskFailedEventAttributes; end
  def activityTaskFailedEventAttributes=(value); end
  def activityTaskFailedEventAttributes?; end
  def activityTaskScheduledEventAttributes; end
  def activityTaskScheduledEventAttributes=(value); end
  def activityTaskScheduledEventAttributes?; end
  def activityTaskStartedEventAttributes; end
  def activityTaskStartedEventAttributes=(value); end
  def activityTaskStartedEventAttributes?; end
  def activityTaskTimedOutEventAttributes; end
  def activityTaskTimedOutEventAttributes=(value); end
  def activityTaskTimedOutEventAttributes?; end
  def cancelTimerFailedEventAttributes; end
  def cancelTimerFailedEventAttributes=(value); end
  def cancelTimerFailedEventAttributes?; end
  def childWorkflowExecutionCanceledEventAttributes; end
  def childWorkflowExecutionCanceledEventAttributes=(value); end
  def childWorkflowExecutionCanceledEventAttributes?; end
  def childWorkflowExecutionCompletedEventAttributes; end
  def childWorkflowExecutionCompletedEventAttributes=(value); end
  def childWorkflowExecutionCompletedEventAttributes?; end
  def childWorkflowExecutionFailedEventAttributes; end
  def childWorkflowExecutionFailedEventAttributes=(value); end
  def childWorkflowExecutionFailedEventAttributes?; end
  def childWorkflowExecutionStartedEventAttributes; end
  def childWorkflowExecutionStartedEventAttributes=(value); end
  def childWorkflowExecutionStartedEventAttributes?; end
  def childWorkflowExecutionTerminatedEventAttributes; end
  def childWorkflowExecutionTerminatedEventAttributes=(value); end
  def childWorkflowExecutionTerminatedEventAttributes?; end
  def childWorkflowExecutionTimedOutEventAttributes; end
  def childWorkflowExecutionTimedOutEventAttributes=(value); end
  def childWorkflowExecutionTimedOutEventAttributes?; end
  def decisionTaskCompletedEventAttributes; end
  def decisionTaskCompletedEventAttributes=(value); end
  def decisionTaskCompletedEventAttributes?; end
  def decisionTaskFailedEventAttributes; end
  def decisionTaskFailedEventAttributes=(value); end
  def decisionTaskFailedEventAttributes?; end
  def decisionTaskScheduledEventAttributes; end
  def decisionTaskScheduledEventAttributes=(value); end
  def decisionTaskScheduledEventAttributes?; end
  def decisionTaskStartedEventAttributes; end
  def decisionTaskStartedEventAttributes=(value); end
  def decisionTaskStartedEventAttributes?; end
  def decisionTaskTimedOutEventAttributes; end
  def decisionTaskTimedOutEventAttributes=(value); end
  def decisionTaskTimedOutEventAttributes?; end
  def eventId; end
  def eventId=(value); end
  def eventId?; end
  def eventType; end
  def eventType=(value); end
  def eventType?; end
  def externalWorkflowExecutionCancelRequestedEventAttributes; end
  def externalWorkflowExecutionCancelRequestedEventAttributes=(value); end
  def externalWorkflowExecutionCancelRequestedEventAttributes?; end
  def externalWorkflowExecutionSignaledEventAttributes; end
  def externalWorkflowExecutionSignaledEventAttributes=(value); end
  def externalWorkflowExecutionSignaledEventAttributes?; end
  def markerRecordedEventAttributes; end
  def markerRecordedEventAttributes=(value); end
  def markerRecordedEventAttributes?; end
  def requestCancelActivityTaskFailedEventAttributes; end
  def requestCancelActivityTaskFailedEventAttributes=(value); end
  def requestCancelActivityTaskFailedEventAttributes?; end
  def requestCancelExternalWorkflowExecutionFailedEventAttributes; end
  def requestCancelExternalWorkflowExecutionFailedEventAttributes=(value); end
  def requestCancelExternalWorkflowExecutionFailedEventAttributes?; end
  def requestCancelExternalWorkflowExecutionInitiatedEventAttributes; end
  def requestCancelExternalWorkflowExecutionInitiatedEventAttributes=(value); end
  def requestCancelExternalWorkflowExecutionInitiatedEventAttributes?; end
  def signalExternalWorkflowExecutionFailedEventAttributes; end
  def signalExternalWorkflowExecutionFailedEventAttributes=(value); end
  def signalExternalWorkflowExecutionFailedEventAttributes?; end
  def signalExternalWorkflowExecutionInitiatedEventAttributes; end
  def signalExternalWorkflowExecutionInitiatedEventAttributes=(value); end
  def signalExternalWorkflowExecutionInitiatedEventAttributes?; end
  def startChildWorkflowExecutionFailedEventAttributes; end
  def startChildWorkflowExecutionFailedEventAttributes=(value); end
  def startChildWorkflowExecutionFailedEventAttributes?; end
  def startChildWorkflowExecutionInitiatedEventAttributes; end
  def startChildWorkflowExecutionInitiatedEventAttributes=(value); end
  def startChildWorkflowExecutionInitiatedEventAttributes?; end
  def struct_fields; end
  def taskId; end
  def taskId=(value); end
  def taskId?; end
  def timerCanceledEventAttributes; end
  def timerCanceledEventAttributes=(value); end
  def timerCanceledEventAttributes?; end
  def timerFiredEventAttributes; end
  def timerFiredEventAttributes=(value); end
  def timerFiredEventAttributes?; end
  def timerStartedEventAttributes; end
  def timerStartedEventAttributes=(value); end
  def timerStartedEventAttributes?; end
  def timestamp; end
  def timestamp=(value); end
  def timestamp?; end
  def upsertWorkflowSearchAttributesEventAttributes; end
  def upsertWorkflowSearchAttributesEventAttributes=(value); end
  def upsertWorkflowSearchAttributesEventAttributes?; end
  def validate; end
  def version; end
  def version=(value); end
  def version?; end
  def workflowExecutionCancelRequestedEventAttributes; end
  def workflowExecutionCancelRequestedEventAttributes=(value); end
  def workflowExecutionCancelRequestedEventAttributes?; end
  def workflowExecutionCanceledEventAttributes; end
  def workflowExecutionCanceledEventAttributes=(value); end
  def workflowExecutionCanceledEventAttributes?; end
  def workflowExecutionCompletedEventAttributes; end
  def workflowExecutionCompletedEventAttributes=(value); end
  def workflowExecutionCompletedEventAttributes?; end
  def workflowExecutionContinuedAsNewEventAttributes; end
  def workflowExecutionContinuedAsNewEventAttributes=(value); end
  def workflowExecutionContinuedAsNewEventAttributes?; end
  def workflowExecutionFailedEventAttributes; end
  def workflowExecutionFailedEventAttributes=(value); end
  def workflowExecutionFailedEventAttributes?; end
  def workflowExecutionSignaledEventAttributes; end
  def workflowExecutionSignaledEventAttributes=(value); end
  def workflowExecutionSignaledEventAttributes?; end
  def workflowExecutionStartedEventAttributes; end
  def workflowExecutionStartedEventAttributes=(value); end
  def workflowExecutionStartedEventAttributes?; end
  def workflowExecutionTerminatedEventAttributes; end
  def workflowExecutionTerminatedEventAttributes=(value); end
  def workflowExecutionTerminatedEventAttributes?; end
  def workflowExecutionTimedOutEventAttributes; end
  def workflowExecutionTimedOutEventAttributes=(value); end
  def workflowExecutionTimedOutEventAttributes?; end
  include Thrift::Struct
end
class CadenceThrift::History
  def events; end
  def events=(value); end
  def events?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::WorkflowExecutionFilter
  def runId; end
  def runId=(value); end
  def runId?; end
  def struct_fields; end
  def validate; end
  def workflowId; end
  def workflowId=(value); end
  def workflowId?; end
  include Thrift::Struct
end
class CadenceThrift::WorkflowTypeFilter
  def name; end
  def name=(value); end
  def name?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::StartTimeFilter
  def earliestTime; end
  def earliestTime=(value); end
  def earliestTime?; end
  def latestTime; end
  def latestTime=(value); end
  def latestTime?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::DomainInfo
  def data; end
  def data=(value); end
  def data?; end
  def description; end
  def description=(value); end
  def description?; end
  def name; end
  def name=(value); end
  def name?; end
  def ownerEmail; end
  def ownerEmail=(value); end
  def ownerEmail?; end
  def status; end
  def status=(value); end
  def status?; end
  def struct_fields; end
  def uuid; end
  def uuid=(value); end
  def uuid?; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::DomainConfiguration
  def badBinaries; end
  def badBinaries=(value); end
  def badBinaries?; end
  def emitMetric; end
  def emitMetric=(value); end
  def emitMetric?; end
  def historyArchivalStatus; end
  def historyArchivalStatus=(value); end
  def historyArchivalStatus?; end
  def historyArchivalURI; end
  def historyArchivalURI=(value); end
  def historyArchivalURI?; end
  def struct_fields; end
  def validate; end
  def visibilityArchivalStatus; end
  def visibilityArchivalStatus=(value); end
  def visibilityArchivalStatus?; end
  def visibilityArchivalURI; end
  def visibilityArchivalURI=(value); end
  def visibilityArchivalURI?; end
  def workflowExecutionRetentionPeriodInDays; end
  def workflowExecutionRetentionPeriodInDays=(value); end
  def workflowExecutionRetentionPeriodInDays?; end
  include Thrift::Struct
end
class CadenceThrift::BadBinaries
  def binaries; end
  def binaries=(value); end
  def binaries?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::BadBinaryInfo
  def createdTimeNano; end
  def createdTimeNano=(value); end
  def createdTimeNano?; end
  def operator; end
  def operator=(value); end
  def operator?; end
  def reason; end
  def reason=(value); end
  def reason?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::UpdateDomainInfo
  def data; end
  def data=(value); end
  def data?; end
  def description; end
  def description=(value); end
  def description?; end
  def ownerEmail; end
  def ownerEmail=(value); end
  def ownerEmail?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::ClusterReplicationConfiguration
  def clusterName; end
  def clusterName=(value); end
  def clusterName?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::DomainReplicationConfiguration
  def activeClusterName; end
  def activeClusterName=(value); end
  def activeClusterName?; end
  def clusters; end
  def clusters=(value); end
  def clusters?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::RegisterDomainRequest
  def activeClusterName; end
  def activeClusterName=(value); end
  def activeClusterName?; end
  def clusters; end
  def clusters=(value); end
  def clusters?; end
  def data; end
  def data=(value); end
  def data?; end
  def description; end
  def description=(value); end
  def description?; end
  def emitMetric; end
  def emitMetric=(value); end
  def emitMetric?; end
  def historyArchivalStatus; end
  def historyArchivalStatus=(value); end
  def historyArchivalStatus?; end
  def historyArchivalURI; end
  def historyArchivalURI=(value); end
  def historyArchivalURI?; end
  def isGlobalDomain; end
  def isGlobalDomain=(value); end
  def isGlobalDomain?; end
  def name; end
  def name=(value); end
  def name?; end
  def ownerEmail; end
  def ownerEmail=(value); end
  def ownerEmail?; end
  def securityToken; end
  def securityToken=(value); end
  def securityToken?; end
  def struct_fields; end
  def validate; end
  def visibilityArchivalStatus; end
  def visibilityArchivalStatus=(value); end
  def visibilityArchivalStatus?; end
  def visibilityArchivalURI; end
  def visibilityArchivalURI=(value); end
  def visibilityArchivalURI?; end
  def workflowExecutionRetentionPeriodInDays; end
  def workflowExecutionRetentionPeriodInDays=(value); end
  def workflowExecutionRetentionPeriodInDays?; end
  include Thrift::Struct
end
class CadenceThrift::ListDomainsRequest
  def nextPageToken; end
  def nextPageToken=(value); end
  def nextPageToken?; end
  def pageSize; end
  def pageSize=(value); end
  def pageSize?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::ListDomainsResponse
  def domains; end
  def domains=(value); end
  def domains?; end
  def nextPageToken; end
  def nextPageToken=(value); end
  def nextPageToken?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::DescribeDomainRequest
  def name; end
  def name=(value); end
  def name?; end
  def struct_fields; end
  def uuid; end
  def uuid=(value); end
  def uuid?; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::DescribeDomainResponse
  def configuration; end
  def configuration=(value); end
  def configuration?; end
  def domainInfo; end
  def domainInfo=(value); end
  def domainInfo?; end
  def failoverVersion; end
  def failoverVersion=(value); end
  def failoverVersion?; end
  def isGlobalDomain; end
  def isGlobalDomain=(value); end
  def isGlobalDomain?; end
  def replicationConfiguration; end
  def replicationConfiguration=(value); end
  def replicationConfiguration?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::UpdateDomainRequest
  def configuration; end
  def configuration=(value); end
  def configuration?; end
  def deleteBadBinary; end
  def deleteBadBinary=(value); end
  def deleteBadBinary?; end
  def name; end
  def name=(value); end
  def name?; end
  def replicationConfiguration; end
  def replicationConfiguration=(value); end
  def replicationConfiguration?; end
  def securityToken; end
  def securityToken=(value); end
  def securityToken?; end
  def struct_fields; end
  def updatedInfo; end
  def updatedInfo=(value); end
  def updatedInfo?; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::UpdateDomainResponse
  def configuration; end
  def configuration=(value); end
  def configuration?; end
  def domainInfo; end
  def domainInfo=(value); end
  def domainInfo?; end
  def failoverVersion; end
  def failoverVersion=(value); end
  def failoverVersion?; end
  def isGlobalDomain; end
  def isGlobalDomain=(value); end
  def isGlobalDomain?; end
  def replicationConfiguration; end
  def replicationConfiguration=(value); end
  def replicationConfiguration?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::DeprecateDomainRequest
  def name; end
  def name=(value); end
  def name?; end
  def securityToken; end
  def securityToken=(value); end
  def securityToken?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::StartWorkflowExecutionRequest
  def cronSchedule; end
  def cronSchedule=(value); end
  def cronSchedule?; end
  def domain; end
  def domain=(value); end
  def domain?; end
  def executionStartToCloseTimeoutSeconds; end
  def executionStartToCloseTimeoutSeconds=(value); end
  def executionStartToCloseTimeoutSeconds?; end
  def header; end
  def header=(value); end
  def header?; end
  def identity; end
  def identity=(value); end
  def identity?; end
  def input; end
  def input=(value); end
  def input?; end
  def memo; end
  def memo=(value); end
  def memo?; end
  def requestId; end
  def requestId=(value); end
  def requestId?; end
  def retryPolicy; end
  def retryPolicy=(value); end
  def retryPolicy?; end
  def searchAttributes; end
  def searchAttributes=(value); end
  def searchAttributes?; end
  def struct_fields; end
  def taskList; end
  def taskList=(value); end
  def taskList?; end
  def taskStartToCloseTimeoutSeconds; end
  def taskStartToCloseTimeoutSeconds=(value); end
  def taskStartToCloseTimeoutSeconds?; end
  def validate; end
  def workflowId; end
  def workflowId=(value); end
  def workflowId?; end
  def workflowIdReusePolicy; end
  def workflowIdReusePolicy=(value); end
  def workflowIdReusePolicy?; end
  def workflowType; end
  def workflowType=(value); end
  def workflowType?; end
  include Thrift::Struct
end
class CadenceThrift::StartWorkflowExecutionResponse
  def runId; end
  def runId=(value); end
  def runId?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::PollForDecisionTaskRequest
  def binaryChecksum; end
  def binaryChecksum=(value); end
  def binaryChecksum?; end
  def domain; end
  def domain=(value); end
  def domain?; end
  def identity; end
  def identity=(value); end
  def identity?; end
  def struct_fields; end
  def taskList; end
  def taskList=(value); end
  def taskList?; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::PollForDecisionTaskResponse
  def WorkflowExecutionTaskList; end
  def WorkflowExecutionTaskList=(value); end
  def WorkflowExecutionTaskList?; end
  def attempt; end
  def attempt=(value); end
  def attempt?; end
  def backlogCountHint; end
  def backlogCountHint=(value); end
  def backlogCountHint?; end
  def history; end
  def history=(value); end
  def history?; end
  def nextPageToken; end
  def nextPageToken=(value); end
  def nextPageToken?; end
  def previousStartedEventId; end
  def previousStartedEventId=(value); end
  def previousStartedEventId?; end
  def queries; end
  def queries=(value); end
  def queries?; end
  def query; end
  def query=(value); end
  def query?; end
  def scheduledTimestamp; end
  def scheduledTimestamp=(value); end
  def scheduledTimestamp?; end
  def startedEventId; end
  def startedEventId=(value); end
  def startedEventId?; end
  def startedTimestamp; end
  def startedTimestamp=(value); end
  def startedTimestamp?; end
  def struct_fields; end
  def taskToken; end
  def taskToken=(value); end
  def taskToken?; end
  def validate; end
  def workflowExecution; end
  def workflowExecution=(value); end
  def workflowExecution?; end
  def workflowType; end
  def workflowType=(value); end
  def workflowType?; end
  include Thrift::Struct
end
class CadenceThrift::StickyExecutionAttributes
  def scheduleToStartTimeoutSeconds; end
  def scheduleToStartTimeoutSeconds=(value); end
  def scheduleToStartTimeoutSeconds?; end
  def struct_fields; end
  def validate; end
  def workerTaskList; end
  def workerTaskList=(value); end
  def workerTaskList?; end
  include Thrift::Struct
end
class CadenceThrift::RespondDecisionTaskCompletedRequest
  def binaryChecksum; end
  def binaryChecksum=(value); end
  def binaryChecksum?; end
  def decisions; end
  def decisions=(value); end
  def decisions?; end
  def executionContext; end
  def executionContext=(value); end
  def executionContext?; end
  def forceCreateNewDecisionTask; end
  def forceCreateNewDecisionTask=(value); end
  def forceCreateNewDecisionTask?; end
  def identity; end
  def identity=(value); end
  def identity?; end
  def queryResults; end
  def queryResults=(value); end
  def queryResults?; end
  def returnNewDecisionTask; end
  def returnNewDecisionTask=(value); end
  def returnNewDecisionTask?; end
  def stickyAttributes; end
  def stickyAttributes=(value); end
  def stickyAttributes?; end
  def struct_fields; end
  def taskToken; end
  def taskToken=(value); end
  def taskToken?; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::RespondDecisionTaskCompletedResponse
  def decisionTask; end
  def decisionTask=(value); end
  def decisionTask?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::RespondDecisionTaskFailedRequest
  def cause; end
  def cause=(value); end
  def cause?; end
  def details; end
  def details=(value); end
  def details?; end
  def identity; end
  def identity=(value); end
  def identity?; end
  def struct_fields; end
  def taskToken; end
  def taskToken=(value); end
  def taskToken?; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::PollForActivityTaskRequest
  def domain; end
  def domain=(value); end
  def domain?; end
  def identity; end
  def identity=(value); end
  def identity?; end
  def struct_fields; end
  def taskList; end
  def taskList=(value); end
  def taskList?; end
  def taskListMetadata; end
  def taskListMetadata=(value); end
  def taskListMetadata?; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::PollForActivityTaskResponse
  def activityId; end
  def activityId=(value); end
  def activityId?; end
  def activityType; end
  def activityType=(value); end
  def activityType?; end
  def attempt; end
  def attempt=(value); end
  def attempt?; end
  def header; end
  def header=(value); end
  def header?; end
  def heartbeatDetails; end
  def heartbeatDetails=(value); end
  def heartbeatDetails?; end
  def heartbeatTimeoutSeconds; end
  def heartbeatTimeoutSeconds=(value); end
  def heartbeatTimeoutSeconds?; end
  def input; end
  def input=(value); end
  def input?; end
  def scheduleToCloseTimeoutSeconds; end
  def scheduleToCloseTimeoutSeconds=(value); end
  def scheduleToCloseTimeoutSeconds?; end
  def scheduledTimestamp; end
  def scheduledTimestamp=(value); end
  def scheduledTimestamp?; end
  def scheduledTimestampOfThisAttempt; end
  def scheduledTimestampOfThisAttempt=(value); end
  def scheduledTimestampOfThisAttempt?; end
  def startToCloseTimeoutSeconds; end
  def startToCloseTimeoutSeconds=(value); end
  def startToCloseTimeoutSeconds?; end
  def startedTimestamp; end
  def startedTimestamp=(value); end
  def startedTimestamp?; end
  def struct_fields; end
  def taskToken; end
  def taskToken=(value); end
  def taskToken?; end
  def validate; end
  def workflowDomain; end
  def workflowDomain=(value); end
  def workflowDomain?; end
  def workflowExecution; end
  def workflowExecution=(value); end
  def workflowExecution?; end
  def workflowType; end
  def workflowType=(value); end
  def workflowType?; end
  include Thrift::Struct
end
class CadenceThrift::RecordActivityTaskHeartbeatRequest
  def details; end
  def details=(value); end
  def details?; end
  def identity; end
  def identity=(value); end
  def identity?; end
  def struct_fields; end
  def taskToken; end
  def taskToken=(value); end
  def taskToken?; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::RecordActivityTaskHeartbeatByIDRequest
  def activityID; end
  def activityID=(value); end
  def activityID?; end
  def details; end
  def details=(value); end
  def details?; end
  def domain; end
  def domain=(value); end
  def domain?; end
  def identity; end
  def identity=(value); end
  def identity?; end
  def runID; end
  def runID=(value); end
  def runID?; end
  def struct_fields; end
  def validate; end
  def workflowID; end
  def workflowID=(value); end
  def workflowID?; end
  include Thrift::Struct
end
class CadenceThrift::RecordActivityTaskHeartbeatResponse
  def cancelRequested; end
  def cancelRequested=(value); end
  def cancelRequested?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::RespondActivityTaskCompletedRequest
  def identity; end
  def identity=(value); end
  def identity?; end
  def result; end
  def result=(value); end
  def result?; end
  def struct_fields; end
  def taskToken; end
  def taskToken=(value); end
  def taskToken?; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::RespondActivityTaskFailedRequest
  def details; end
  def details=(value); end
  def details?; end
  def identity; end
  def identity=(value); end
  def identity?; end
  def reason; end
  def reason=(value); end
  def reason?; end
  def struct_fields; end
  def taskToken; end
  def taskToken=(value); end
  def taskToken?; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::RespondActivityTaskCanceledRequest
  def details; end
  def details=(value); end
  def details?; end
  def identity; end
  def identity=(value); end
  def identity?; end
  def struct_fields; end
  def taskToken; end
  def taskToken=(value); end
  def taskToken?; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::RespondActivityTaskCompletedByIDRequest
  def activityID; end
  def activityID=(value); end
  def activityID?; end
  def domain; end
  def domain=(value); end
  def domain?; end
  def identity; end
  def identity=(value); end
  def identity?; end
  def result; end
  def result=(value); end
  def result?; end
  def runID; end
  def runID=(value); end
  def runID?; end
  def struct_fields; end
  def validate; end
  def workflowID; end
  def workflowID=(value); end
  def workflowID?; end
  include Thrift::Struct
end
class CadenceThrift::RespondActivityTaskFailedByIDRequest
  def activityID; end
  def activityID=(value); end
  def activityID?; end
  def details; end
  def details=(value); end
  def details?; end
  def domain; end
  def domain=(value); end
  def domain?; end
  def identity; end
  def identity=(value); end
  def identity?; end
  def reason; end
  def reason=(value); end
  def reason?; end
  def runID; end
  def runID=(value); end
  def runID?; end
  def struct_fields; end
  def validate; end
  def workflowID; end
  def workflowID=(value); end
  def workflowID?; end
  include Thrift::Struct
end
class CadenceThrift::RespondActivityTaskCanceledByIDRequest
  def activityID; end
  def activityID=(value); end
  def activityID?; end
  def details; end
  def details=(value); end
  def details?; end
  def domain; end
  def domain=(value); end
  def domain?; end
  def identity; end
  def identity=(value); end
  def identity?; end
  def runID; end
  def runID=(value); end
  def runID?; end
  def struct_fields; end
  def validate; end
  def workflowID; end
  def workflowID=(value); end
  def workflowID?; end
  include Thrift::Struct
end
class CadenceThrift::RequestCancelWorkflowExecutionRequest
  def domain; end
  def domain=(value); end
  def domain?; end
  def identity; end
  def identity=(value); end
  def identity?; end
  def requestId; end
  def requestId=(value); end
  def requestId?; end
  def struct_fields; end
  def validate; end
  def workflowExecution; end
  def workflowExecution=(value); end
  def workflowExecution?; end
  include Thrift::Struct
end
class CadenceThrift::GetWorkflowExecutionHistoryRequest
  def HistoryEventFilterType; end
  def HistoryEventFilterType=(value); end
  def HistoryEventFilterType?; end
  def domain; end
  def domain=(value); end
  def domain?; end
  def execution; end
  def execution=(value); end
  def execution?; end
  def maximumPageSize; end
  def maximumPageSize=(value); end
  def maximumPageSize?; end
  def nextPageToken; end
  def nextPageToken=(value); end
  def nextPageToken?; end
  def struct_fields; end
  def validate; end
  def waitForNewEvent; end
  def waitForNewEvent=(value); end
  def waitForNewEvent?; end
  include Thrift::Struct
end
class CadenceThrift::GetWorkflowExecutionHistoryResponse
  def archived; end
  def archived=(value); end
  def archived?; end
  def history; end
  def history=(value); end
  def history?; end
  def nextPageToken; end
  def nextPageToken=(value); end
  def nextPageToken?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::SignalWorkflowExecutionRequest
  def control; end
  def control=(value); end
  def control?; end
  def domain; end
  def domain=(value); end
  def domain?; end
  def identity; end
  def identity=(value); end
  def identity?; end
  def input; end
  def input=(value); end
  def input?; end
  def requestId; end
  def requestId=(value); end
  def requestId?; end
  def signalName; end
  def signalName=(value); end
  def signalName?; end
  def struct_fields; end
  def validate; end
  def workflowExecution; end
  def workflowExecution=(value); end
  def workflowExecution?; end
  include Thrift::Struct
end
class CadenceThrift::SignalWithStartWorkflowExecutionRequest
  def control; end
  def control=(value); end
  def control?; end
  def cronSchedule; end
  def cronSchedule=(value); end
  def cronSchedule?; end
  def domain; end
  def domain=(value); end
  def domain?; end
  def executionStartToCloseTimeoutSeconds; end
  def executionStartToCloseTimeoutSeconds=(value); end
  def executionStartToCloseTimeoutSeconds?; end
  def header; end
  def header=(value); end
  def header?; end
  def identity; end
  def identity=(value); end
  def identity?; end
  def input; end
  def input=(value); end
  def input?; end
  def memo; end
  def memo=(value); end
  def memo?; end
  def requestId; end
  def requestId=(value); end
  def requestId?; end
  def retryPolicy; end
  def retryPolicy=(value); end
  def retryPolicy?; end
  def searchAttributes; end
  def searchAttributes=(value); end
  def searchAttributes?; end
  def signalInput; end
  def signalInput=(value); end
  def signalInput?; end
  def signalName; end
  def signalName=(value); end
  def signalName?; end
  def struct_fields; end
  def taskList; end
  def taskList=(value); end
  def taskList?; end
  def taskStartToCloseTimeoutSeconds; end
  def taskStartToCloseTimeoutSeconds=(value); end
  def taskStartToCloseTimeoutSeconds?; end
  def validate; end
  def workflowId; end
  def workflowId=(value); end
  def workflowId?; end
  def workflowIdReusePolicy; end
  def workflowIdReusePolicy=(value); end
  def workflowIdReusePolicy?; end
  def workflowType; end
  def workflowType=(value); end
  def workflowType?; end
  include Thrift::Struct
end
class CadenceThrift::TerminateWorkflowExecutionRequest
  def details; end
  def details=(value); end
  def details?; end
  def domain; end
  def domain=(value); end
  def domain?; end
  def identity; end
  def identity=(value); end
  def identity?; end
  def reason; end
  def reason=(value); end
  def reason?; end
  def struct_fields; end
  def validate; end
  def workflowExecution; end
  def workflowExecution=(value); end
  def workflowExecution?; end
  include Thrift::Struct
end
class CadenceThrift::ResetWorkflowExecutionRequest
  def decisionFinishEventId; end
  def decisionFinishEventId=(value); end
  def decisionFinishEventId?; end
  def domain; end
  def domain=(value); end
  def domain?; end
  def reason; end
  def reason=(value); end
  def reason?; end
  def requestId; end
  def requestId=(value); end
  def requestId?; end
  def struct_fields; end
  def validate; end
  def workflowExecution; end
  def workflowExecution=(value); end
  def workflowExecution?; end
  include Thrift::Struct
end
class CadenceThrift::ResetWorkflowExecutionResponse
  def runId; end
  def runId=(value); end
  def runId?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::ListOpenWorkflowExecutionsRequest
  def StartTimeFilter; end
  def StartTimeFilter=(value); end
  def StartTimeFilter?; end
  def domain; end
  def domain=(value); end
  def domain?; end
  def executionFilter; end
  def executionFilter=(value); end
  def executionFilter?; end
  def maximumPageSize; end
  def maximumPageSize=(value); end
  def maximumPageSize?; end
  def nextPageToken; end
  def nextPageToken=(value); end
  def nextPageToken?; end
  def struct_fields; end
  def typeFilter; end
  def typeFilter=(value); end
  def typeFilter?; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::ListOpenWorkflowExecutionsResponse
  def executions; end
  def executions=(value); end
  def executions?; end
  def nextPageToken; end
  def nextPageToken=(value); end
  def nextPageToken?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::ListClosedWorkflowExecutionsRequest
  def StartTimeFilter; end
  def StartTimeFilter=(value); end
  def StartTimeFilter?; end
  def domain; end
  def domain=(value); end
  def domain?; end
  def executionFilter; end
  def executionFilter=(value); end
  def executionFilter?; end
  def maximumPageSize; end
  def maximumPageSize=(value); end
  def maximumPageSize?; end
  def nextPageToken; end
  def nextPageToken=(value); end
  def nextPageToken?; end
  def statusFilter; end
  def statusFilter=(value); end
  def statusFilter?; end
  def struct_fields; end
  def typeFilter; end
  def typeFilter=(value); end
  def typeFilter?; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::ListClosedWorkflowExecutionsResponse
  def executions; end
  def executions=(value); end
  def executions?; end
  def nextPageToken; end
  def nextPageToken=(value); end
  def nextPageToken?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::ListWorkflowExecutionsRequest
  def domain; end
  def domain=(value); end
  def domain?; end
  def nextPageToken; end
  def nextPageToken=(value); end
  def nextPageToken?; end
  def pageSize; end
  def pageSize=(value); end
  def pageSize?; end
  def query; end
  def query=(value); end
  def query?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::ListWorkflowExecutionsResponse
  def executions; end
  def executions=(value); end
  def executions?; end
  def nextPageToken; end
  def nextPageToken=(value); end
  def nextPageToken?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::ListArchivedWorkflowExecutionsRequest
  def domain; end
  def domain=(value); end
  def domain?; end
  def nextPageToken; end
  def nextPageToken=(value); end
  def nextPageToken?; end
  def pageSize; end
  def pageSize=(value); end
  def pageSize?; end
  def query; end
  def query=(value); end
  def query?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::ListArchivedWorkflowExecutionsResponse
  def executions; end
  def executions=(value); end
  def executions?; end
  def nextPageToken; end
  def nextPageToken=(value); end
  def nextPageToken?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::CountWorkflowExecutionsRequest
  def domain; end
  def domain=(value); end
  def domain?; end
  def query; end
  def query=(value); end
  def query?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::CountWorkflowExecutionsResponse
  def count; end
  def count=(value); end
  def count?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::GetSearchAttributesResponse
  def keys; end
  def keys=(value); end
  def keys?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::QueryWorkflowRequest
  def domain; end
  def domain=(value); end
  def domain?; end
  def execution; end
  def execution=(value); end
  def execution?; end
  def query; end
  def query=(value); end
  def query?; end
  def queryRejectCondition; end
  def queryRejectCondition=(value); end
  def queryRejectCondition?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::QueryRejected
  def closeStatus; end
  def closeStatus=(value); end
  def closeStatus?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::QueryWorkflowResponse
  def queryRejected; end
  def queryRejected=(value); end
  def queryRejected?; end
  def queryResult; end
  def queryResult=(value); end
  def queryResult?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::WorkflowQuery
  def queryArgs; end
  def queryArgs=(value); end
  def queryArgs?; end
  def queryType; end
  def queryType=(value); end
  def queryType?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::ResetStickyTaskListRequest
  def domain; end
  def domain=(value); end
  def domain?; end
  def execution; end
  def execution=(value); end
  def execution?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::ResetStickyTaskListResponse
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::RespondQueryTaskCompletedRequest
  def completedType; end
  def completedType=(value); end
  def completedType?; end
  def errorMessage; end
  def errorMessage=(value); end
  def errorMessage?; end
  def queryResult; end
  def queryResult=(value); end
  def queryResult?; end
  def struct_fields; end
  def taskToken; end
  def taskToken=(value); end
  def taskToken?; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::WorkflowQueryResult
  def answer; end
  def answer=(value); end
  def answer?; end
  def errorDetails; end
  def errorDetails=(value); end
  def errorDetails?; end
  def errorReason; end
  def errorReason=(value); end
  def errorReason?; end
  def resultType; end
  def resultType=(value); end
  def resultType?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::DescribeWorkflowExecutionRequest
  def domain; end
  def domain=(value); end
  def domain?; end
  def execution; end
  def execution=(value); end
  def execution?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::PendingActivityInfo
  def activityID; end
  def activityID=(value); end
  def activityID?; end
  def activityType; end
  def activityType=(value); end
  def activityType?; end
  def attempt; end
  def attempt=(value); end
  def attempt?; end
  def expirationTimestamp; end
  def expirationTimestamp=(value); end
  def expirationTimestamp?; end
  def heartbeatDetails; end
  def heartbeatDetails=(value); end
  def heartbeatDetails?; end
  def lastFailureDetails; end
  def lastFailureDetails=(value); end
  def lastFailureDetails?; end
  def lastFailureReason; end
  def lastFailureReason=(value); end
  def lastFailureReason?; end
  def lastHeartbeatTimestamp; end
  def lastHeartbeatTimestamp=(value); end
  def lastHeartbeatTimestamp?; end
  def lastStartedTimestamp; end
  def lastStartedTimestamp=(value); end
  def lastStartedTimestamp?; end
  def lastWorkerIdentity; end
  def lastWorkerIdentity=(value); end
  def lastWorkerIdentity?; end
  def maximumAttempts; end
  def maximumAttempts=(value); end
  def maximumAttempts?; end
  def scheduledTimestamp; end
  def scheduledTimestamp=(value); end
  def scheduledTimestamp?; end
  def state; end
  def state=(value); end
  def state?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::PendingChildExecutionInfo
  def initiatedID; end
  def initiatedID=(value); end
  def initiatedID?; end
  def parentClosePolicy; end
  def parentClosePolicy=(value); end
  def parentClosePolicy?; end
  def runID; end
  def runID=(value); end
  def runID?; end
  def struct_fields; end
  def validate; end
  def workflowID; end
  def workflowID=(value); end
  def workflowID?; end
  def workflowTypName; end
  def workflowTypName=(value); end
  def workflowTypName?; end
  include Thrift::Struct
end
class CadenceThrift::DescribeWorkflowExecutionResponse
  def executionConfiguration; end
  def executionConfiguration=(value); end
  def executionConfiguration?; end
  def pendingActivities; end
  def pendingActivities=(value); end
  def pendingActivities?; end
  def pendingChildren; end
  def pendingChildren=(value); end
  def pendingChildren?; end
  def struct_fields; end
  def validate; end
  def workflowExecutionInfo; end
  def workflowExecutionInfo=(value); end
  def workflowExecutionInfo?; end
  include Thrift::Struct
end
class CadenceThrift::DescribeTaskListRequest
  def domain; end
  def domain=(value); end
  def domain?; end
  def includeTaskListStatus; end
  def includeTaskListStatus=(value); end
  def includeTaskListStatus?; end
  def struct_fields; end
  def taskList; end
  def taskList=(value); end
  def taskList?; end
  def taskListType; end
  def taskListType=(value); end
  def taskListType?; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::DescribeTaskListResponse
  def pollers; end
  def pollers=(value); end
  def pollers?; end
  def struct_fields; end
  def taskListStatus; end
  def taskListStatus=(value); end
  def taskListStatus?; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::TaskListStatus
  def ackLevel; end
  def ackLevel=(value); end
  def ackLevel?; end
  def backlogCountHint; end
  def backlogCountHint=(value); end
  def backlogCountHint?; end
  def ratePerSecond; end
  def ratePerSecond=(value); end
  def ratePerSecond?; end
  def readLevel; end
  def readLevel=(value); end
  def readLevel?; end
  def struct_fields; end
  def taskIDBlock; end
  def taskIDBlock=(value); end
  def taskIDBlock?; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::TaskIDBlock
  def endID; end
  def endID=(value); end
  def endID?; end
  def startID; end
  def startID=(value); end
  def startID?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::DescribeHistoryHostRequest
  def executionForHost; end
  def executionForHost=(value); end
  def executionForHost?; end
  def hostAddress; end
  def hostAddress=(value); end
  def hostAddress?; end
  def shardIdForHost; end
  def shardIdForHost=(value); end
  def shardIdForHost?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::RemoveTaskRequest
  def shardID; end
  def shardID=(value); end
  def shardID?; end
  def struct_fields; end
  def taskID; end
  def taskID=(value); end
  def taskID?; end
  def type; end
  def type=(value); end
  def type?; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::CloseShardRequest
  def shardID; end
  def shardID=(value); end
  def shardID?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::DescribeHistoryHostResponse
  def address; end
  def address=(value); end
  def address?; end
  def domainCache; end
  def domainCache=(value); end
  def domainCache?; end
  def numberOfShards; end
  def numberOfShards=(value); end
  def numberOfShards?; end
  def shardControllerStatus; end
  def shardControllerStatus=(value); end
  def shardControllerStatus?; end
  def shardIDs; end
  def shardIDs=(value); end
  def shardIDs?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::DomainCacheInfo
  def numOfItemsInCacheByID; end
  def numOfItemsInCacheByID=(value); end
  def numOfItemsInCacheByID?; end
  def numOfItemsInCacheByName; end
  def numOfItemsInCacheByName=(value); end
  def numOfItemsInCacheByName?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::PollerInfo
  def identity; end
  def identity=(value); end
  def identity?; end
  def lastAccessTime; end
  def lastAccessTime=(value); end
  def lastAccessTime?; end
  def ratePerSecond; end
  def ratePerSecond=(value); end
  def ratePerSecond?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::RetryPolicy
  def backoffCoefficient; end
  def backoffCoefficient=(value); end
  def backoffCoefficient?; end
  def expirationIntervalInSeconds; end
  def expirationIntervalInSeconds=(value); end
  def expirationIntervalInSeconds?; end
  def initialIntervalInSeconds; end
  def initialIntervalInSeconds=(value); end
  def initialIntervalInSeconds?; end
  def maximumAttempts; end
  def maximumAttempts=(value); end
  def maximumAttempts?; end
  def maximumIntervalInSeconds; end
  def maximumIntervalInSeconds=(value); end
  def maximumIntervalInSeconds?; end
  def nonRetriableErrorReasons; end
  def nonRetriableErrorReasons=(value); end
  def nonRetriableErrorReasons?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::HistoryBranchRange
  def beginNodeID; end
  def beginNodeID=(value); end
  def beginNodeID?; end
  def branchID; end
  def branchID=(value); end
  def branchID?; end
  def endNodeID; end
  def endNodeID=(value); end
  def endNodeID?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::HistoryBranch
  def ancestors; end
  def ancestors=(value); end
  def ancestors?; end
  def branchID; end
  def branchID=(value); end
  def branchID?; end
  def struct_fields; end
  def treeID; end
  def treeID=(value); end
  def treeID?; end
  def validate; end
  include Thrift::Struct
end
module CadenceThrift::WorkflowService
end
class CadenceThrift::WorkflowService::Client
  def CountWorkflowExecutions(countRequest); end
  def DeprecateDomain(deprecateRequest); end
  def DescribeDomain(describeRequest); end
  def DescribeTaskList(request); end
  def DescribeWorkflowExecution(describeRequest); end
  def GetSearchAttributes; end
  def GetWorkflowExecutionHistory(getRequest); end
  def ListArchivedWorkflowExecutions(listRequest); end
  def ListClosedWorkflowExecutions(listRequest); end
  def ListDomains(listRequest); end
  def ListOpenWorkflowExecutions(listRequest); end
  def ListWorkflowExecutions(listRequest); end
  def PollForActivityTask(pollRequest); end
  def PollForDecisionTask(pollRequest); end
  def QueryWorkflow(queryRequest); end
  def RecordActivityTaskHeartbeat(heartbeatRequest); end
  def RecordActivityTaskHeartbeatByID(heartbeatRequest); end
  def RegisterDomain(registerRequest); end
  def RequestCancelWorkflowExecution(cancelRequest); end
  def ResetStickyTaskList(resetRequest); end
  def ResetWorkflowExecution(resetRequest); end
  def RespondActivityTaskCanceled(canceledRequest); end
  def RespondActivityTaskCanceledByID(canceledRequest); end
  def RespondActivityTaskCompleted(completeRequest); end
  def RespondActivityTaskCompletedByID(completeRequest); end
  def RespondActivityTaskFailed(failRequest); end
  def RespondActivityTaskFailedByID(failRequest); end
  def RespondDecisionTaskCompleted(completeRequest); end
  def RespondDecisionTaskFailed(failedRequest); end
  def RespondQueryTaskCompleted(completeRequest); end
  def ScanWorkflowExecutions(listRequest); end
  def SignalWithStartWorkflowExecution(signalWithStartRequest); end
  def SignalWorkflowExecution(signalRequest); end
  def StartWorkflowExecution(startRequest); end
  def TerminateWorkflowExecution(terminateRequest); end
  def UpdateDomain(updateRequest); end
  def recv_CountWorkflowExecutions; end
  def recv_DeprecateDomain; end
  def recv_DescribeDomain; end
  def recv_DescribeTaskList; end
  def recv_DescribeWorkflowExecution; end
  def recv_GetSearchAttributes; end
  def recv_GetWorkflowExecutionHistory; end
  def recv_ListArchivedWorkflowExecutions; end
  def recv_ListClosedWorkflowExecutions; end
  def recv_ListDomains; end
  def recv_ListOpenWorkflowExecutions; end
  def recv_ListWorkflowExecutions; end
  def recv_PollForActivityTask; end
  def recv_PollForDecisionTask; end
  def recv_QueryWorkflow; end
  def recv_RecordActivityTaskHeartbeat; end
  def recv_RecordActivityTaskHeartbeatByID; end
  def recv_RegisterDomain; end
  def recv_RequestCancelWorkflowExecution; end
  def recv_ResetStickyTaskList; end
  def recv_ResetWorkflowExecution; end
  def recv_RespondActivityTaskCanceled; end
  def recv_RespondActivityTaskCanceledByID; end
  def recv_RespondActivityTaskCompleted; end
  def recv_RespondActivityTaskCompletedByID; end
  def recv_RespondActivityTaskFailed; end
  def recv_RespondActivityTaskFailedByID; end
  def recv_RespondDecisionTaskCompleted; end
  def recv_RespondDecisionTaskFailed; end
  def recv_RespondQueryTaskCompleted; end
  def recv_ScanWorkflowExecutions; end
  def recv_SignalWithStartWorkflowExecution; end
  def recv_SignalWorkflowExecution; end
  def recv_StartWorkflowExecution; end
  def recv_TerminateWorkflowExecution; end
  def recv_UpdateDomain; end
  def send_CountWorkflowExecutions(countRequest); end
  def send_DeprecateDomain(deprecateRequest); end
  def send_DescribeDomain(describeRequest); end
  def send_DescribeTaskList(request); end
  def send_DescribeWorkflowExecution(describeRequest); end
  def send_GetSearchAttributes; end
  def send_GetWorkflowExecutionHistory(getRequest); end
  def send_ListArchivedWorkflowExecutions(listRequest); end
  def send_ListClosedWorkflowExecutions(listRequest); end
  def send_ListDomains(listRequest); end
  def send_ListOpenWorkflowExecutions(listRequest); end
  def send_ListWorkflowExecutions(listRequest); end
  def send_PollForActivityTask(pollRequest); end
  def send_PollForDecisionTask(pollRequest); end
  def send_QueryWorkflow(queryRequest); end
  def send_RecordActivityTaskHeartbeat(heartbeatRequest); end
  def send_RecordActivityTaskHeartbeatByID(heartbeatRequest); end
  def send_RegisterDomain(registerRequest); end
  def send_RequestCancelWorkflowExecution(cancelRequest); end
  def send_ResetStickyTaskList(resetRequest); end
  def send_ResetWorkflowExecution(resetRequest); end
  def send_RespondActivityTaskCanceled(canceledRequest); end
  def send_RespondActivityTaskCanceledByID(canceledRequest); end
  def send_RespondActivityTaskCompleted(completeRequest); end
  def send_RespondActivityTaskCompletedByID(completeRequest); end
  def send_RespondActivityTaskFailed(failRequest); end
  def send_RespondActivityTaskFailedByID(failRequest); end
  def send_RespondDecisionTaskCompleted(completeRequest); end
  def send_RespondDecisionTaskFailed(failedRequest); end
  def send_RespondQueryTaskCompleted(completeRequest); end
  def send_ScanWorkflowExecutions(listRequest); end
  def send_SignalWithStartWorkflowExecution(signalWithStartRequest); end
  def send_SignalWorkflowExecution(signalRequest); end
  def send_StartWorkflowExecution(startRequest); end
  def send_TerminateWorkflowExecution(terminateRequest); end
  def send_UpdateDomain(updateRequest); end
  include Thrift::Client
end
class CadenceThrift::WorkflowService::Processor
  def process_CountWorkflowExecutions(seqid, iprot, oprot); end
  def process_DeprecateDomain(seqid, iprot, oprot); end
  def process_DescribeDomain(seqid, iprot, oprot); end
  def process_DescribeTaskList(seqid, iprot, oprot); end
  def process_DescribeWorkflowExecution(seqid, iprot, oprot); end
  def process_GetSearchAttributes(seqid, iprot, oprot); end
  def process_GetWorkflowExecutionHistory(seqid, iprot, oprot); end
  def process_ListArchivedWorkflowExecutions(seqid, iprot, oprot); end
  def process_ListClosedWorkflowExecutions(seqid, iprot, oprot); end
  def process_ListDomains(seqid, iprot, oprot); end
  def process_ListOpenWorkflowExecutions(seqid, iprot, oprot); end
  def process_ListWorkflowExecutions(seqid, iprot, oprot); end
  def process_PollForActivityTask(seqid, iprot, oprot); end
  def process_PollForDecisionTask(seqid, iprot, oprot); end
  def process_QueryWorkflow(seqid, iprot, oprot); end
  def process_RecordActivityTaskHeartbeat(seqid, iprot, oprot); end
  def process_RecordActivityTaskHeartbeatByID(seqid, iprot, oprot); end
  def process_RegisterDomain(seqid, iprot, oprot); end
  def process_RequestCancelWorkflowExecution(seqid, iprot, oprot); end
  def process_ResetStickyTaskList(seqid, iprot, oprot); end
  def process_ResetWorkflowExecution(seqid, iprot, oprot); end
  def process_RespondActivityTaskCanceled(seqid, iprot, oprot); end
  def process_RespondActivityTaskCanceledByID(seqid, iprot, oprot); end
  def process_RespondActivityTaskCompleted(seqid, iprot, oprot); end
  def process_RespondActivityTaskCompletedByID(seqid, iprot, oprot); end
  def process_RespondActivityTaskFailed(seqid, iprot, oprot); end
  def process_RespondActivityTaskFailedByID(seqid, iprot, oprot); end
  def process_RespondDecisionTaskCompleted(seqid, iprot, oprot); end
  def process_RespondDecisionTaskFailed(seqid, iprot, oprot); end
  def process_RespondQueryTaskCompleted(seqid, iprot, oprot); end
  def process_ScanWorkflowExecutions(seqid, iprot, oprot); end
  def process_SignalWithStartWorkflowExecution(seqid, iprot, oprot); end
  def process_SignalWorkflowExecution(seqid, iprot, oprot); end
  def process_StartWorkflowExecution(seqid, iprot, oprot); end
  def process_TerminateWorkflowExecution(seqid, iprot, oprot); end
  def process_UpdateDomain(seqid, iprot, oprot); end
  include Thrift::Processor
end
class CadenceThrift::WorkflowService::RegisterDomain_args
  def registerRequest; end
  def registerRequest=(value); end
  def registerRequest?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::WorkflowService::RegisterDomain_result
  def badRequestError; end
  def badRequestError=(value); end
  def badRequestError?; end
  def clientVersionNotSupportedError; end
  def clientVersionNotSupportedError=(value); end
  def clientVersionNotSupportedError?; end
  def domainExistsError; end
  def domainExistsError=(value); end
  def domainExistsError?; end
  def internalServiceError; end
  def internalServiceError=(value); end
  def internalServiceError?; end
  def serviceBusyError; end
  def serviceBusyError=(value); end
  def serviceBusyError?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::WorkflowService::DescribeDomain_args
  def describeRequest; end
  def describeRequest=(value); end
  def describeRequest?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::WorkflowService::DescribeDomain_result
  def badRequestError; end
  def badRequestError=(value); end
  def badRequestError?; end
  def clientVersionNotSupportedError; end
  def clientVersionNotSupportedError=(value); end
  def clientVersionNotSupportedError?; end
  def entityNotExistError; end
  def entityNotExistError=(value); end
  def entityNotExistError?; end
  def internalServiceError; end
  def internalServiceError=(value); end
  def internalServiceError?; end
  def serviceBusyError; end
  def serviceBusyError=(value); end
  def serviceBusyError?; end
  def struct_fields; end
  def success; end
  def success=(value); end
  def success?; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::WorkflowService::ListDomains_args
  def listRequest; end
  def listRequest=(value); end
  def listRequest?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::WorkflowService::ListDomains_result
  def badRequestError; end
  def badRequestError=(value); end
  def badRequestError?; end
  def clientVersionNotSupportedError; end
  def clientVersionNotSupportedError=(value); end
  def clientVersionNotSupportedError?; end
  def entityNotExistError; end
  def entityNotExistError=(value); end
  def entityNotExistError?; end
  def internalServiceError; end
  def internalServiceError=(value); end
  def internalServiceError?; end
  def serviceBusyError; end
  def serviceBusyError=(value); end
  def serviceBusyError?; end
  def struct_fields; end
  def success; end
  def success=(value); end
  def success?; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::WorkflowService::UpdateDomain_args
  def struct_fields; end
  def updateRequest; end
  def updateRequest=(value); end
  def updateRequest?; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::WorkflowService::UpdateDomain_result
  def badRequestError; end
  def badRequestError=(value); end
  def badRequestError?; end
  def clientVersionNotSupportedError; end
  def clientVersionNotSupportedError=(value); end
  def clientVersionNotSupportedError?; end
  def domainNotActiveError; end
  def domainNotActiveError=(value); end
  def domainNotActiveError?; end
  def entityNotExistError; end
  def entityNotExistError=(value); end
  def entityNotExistError?; end
  def internalServiceError; end
  def internalServiceError=(value); end
  def internalServiceError?; end
  def serviceBusyError; end
  def serviceBusyError=(value); end
  def serviceBusyError?; end
  def struct_fields; end
  def success; end
  def success=(value); end
  def success?; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::WorkflowService::DeprecateDomain_args
  def deprecateRequest; end
  def deprecateRequest=(value); end
  def deprecateRequest?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::WorkflowService::DeprecateDomain_result
  def badRequestError; end
  def badRequestError=(value); end
  def badRequestError?; end
  def clientVersionNotSupportedError; end
  def clientVersionNotSupportedError=(value); end
  def clientVersionNotSupportedError?; end
  def domainNotActiveError; end
  def domainNotActiveError=(value); end
  def domainNotActiveError?; end
  def entityNotExistError; end
  def entityNotExistError=(value); end
  def entityNotExistError?; end
  def internalServiceError; end
  def internalServiceError=(value); end
  def internalServiceError?; end
  def serviceBusyError; end
  def serviceBusyError=(value); end
  def serviceBusyError?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::WorkflowService::StartWorkflowExecution_args
  def startRequest; end
  def startRequest=(value); end
  def startRequest?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::WorkflowService::StartWorkflowExecution_result
  def badRequestError; end
  def badRequestError=(value); end
  def badRequestError?; end
  def clientVersionNotSupportedError; end
  def clientVersionNotSupportedError=(value); end
  def clientVersionNotSupportedError?; end
  def domainNotActiveError; end
  def domainNotActiveError=(value); end
  def domainNotActiveError?; end
  def entityNotExistError; end
  def entityNotExistError=(value); end
  def entityNotExistError?; end
  def internalServiceError; end
  def internalServiceError=(value); end
  def internalServiceError?; end
  def limitExceededError; end
  def limitExceededError=(value); end
  def limitExceededError?; end
  def serviceBusyError; end
  def serviceBusyError=(value); end
  def serviceBusyError?; end
  def sessionAlreadyExistError; end
  def sessionAlreadyExistError=(value); end
  def sessionAlreadyExistError?; end
  def struct_fields; end
  def success; end
  def success=(value); end
  def success?; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::WorkflowService::GetWorkflowExecutionHistory_args
  def getRequest; end
  def getRequest=(value); end
  def getRequest?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::WorkflowService::GetWorkflowExecutionHistory_result
  def badRequestError; end
  def badRequestError=(value); end
  def badRequestError?; end
  def clientVersionNotSupportedError; end
  def clientVersionNotSupportedError=(value); end
  def clientVersionNotSupportedError?; end
  def entityNotExistError; end
  def entityNotExistError=(value); end
  def entityNotExistError?; end
  def internalServiceError; end
  def internalServiceError=(value); end
  def internalServiceError?; end
  def serviceBusyError; end
  def serviceBusyError=(value); end
  def serviceBusyError?; end
  def struct_fields; end
  def success; end
  def success=(value); end
  def success?; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::WorkflowService::PollForDecisionTask_args
  def pollRequest; end
  def pollRequest=(value); end
  def pollRequest?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::WorkflowService::PollForDecisionTask_result
  def badRequestError; end
  def badRequestError=(value); end
  def badRequestError?; end
  def clientVersionNotSupportedError; end
  def clientVersionNotSupportedError=(value); end
  def clientVersionNotSupportedError?; end
  def domainNotActiveError; end
  def domainNotActiveError=(value); end
  def domainNotActiveError?; end
  def entityNotExistError; end
  def entityNotExistError=(value); end
  def entityNotExistError?; end
  def internalServiceError; end
  def internalServiceError=(value); end
  def internalServiceError?; end
  def limitExceededError; end
  def limitExceededError=(value); end
  def limitExceededError?; end
  def serviceBusyError; end
  def serviceBusyError=(value); end
  def serviceBusyError?; end
  def struct_fields; end
  def success; end
  def success=(value); end
  def success?; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::WorkflowService::RespondDecisionTaskCompleted_args
  def completeRequest; end
  def completeRequest=(value); end
  def completeRequest?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::WorkflowService::RespondDecisionTaskCompleted_result
  def badRequestError; end
  def badRequestError=(value); end
  def badRequestError?; end
  def clientVersionNotSupportedError; end
  def clientVersionNotSupportedError=(value); end
  def clientVersionNotSupportedError?; end
  def domainNotActiveError; end
  def domainNotActiveError=(value); end
  def domainNotActiveError?; end
  def entityNotExistError; end
  def entityNotExistError=(value); end
  def entityNotExistError?; end
  def internalServiceError; end
  def internalServiceError=(value); end
  def internalServiceError?; end
  def limitExceededError; end
  def limitExceededError=(value); end
  def limitExceededError?; end
  def serviceBusyError; end
  def serviceBusyError=(value); end
  def serviceBusyError?; end
  def struct_fields; end
  def success; end
  def success=(value); end
  def success?; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::WorkflowService::RespondDecisionTaskFailed_args
  def failedRequest; end
  def failedRequest=(value); end
  def failedRequest?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::WorkflowService::RespondDecisionTaskFailed_result
  def badRequestError; end
  def badRequestError=(value); end
  def badRequestError?; end
  def clientVersionNotSupportedError; end
  def clientVersionNotSupportedError=(value); end
  def clientVersionNotSupportedError?; end
  def domainNotActiveError; end
  def domainNotActiveError=(value); end
  def domainNotActiveError?; end
  def entityNotExistError; end
  def entityNotExistError=(value); end
  def entityNotExistError?; end
  def internalServiceError; end
  def internalServiceError=(value); end
  def internalServiceError?; end
  def limitExceededError; end
  def limitExceededError=(value); end
  def limitExceededError?; end
  def serviceBusyError; end
  def serviceBusyError=(value); end
  def serviceBusyError?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::WorkflowService::PollForActivityTask_args
  def pollRequest; end
  def pollRequest=(value); end
  def pollRequest?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::WorkflowService::PollForActivityTask_result
  def badRequestError; end
  def badRequestError=(value); end
  def badRequestError?; end
  def clientVersionNotSupportedError; end
  def clientVersionNotSupportedError=(value); end
  def clientVersionNotSupportedError?; end
  def domainNotActiveError; end
  def domainNotActiveError=(value); end
  def domainNotActiveError?; end
  def entityNotExistError; end
  def entityNotExistError=(value); end
  def entityNotExistError?; end
  def internalServiceError; end
  def internalServiceError=(value); end
  def internalServiceError?; end
  def limitExceededError; end
  def limitExceededError=(value); end
  def limitExceededError?; end
  def serviceBusyError; end
  def serviceBusyError=(value); end
  def serviceBusyError?; end
  def struct_fields; end
  def success; end
  def success=(value); end
  def success?; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::WorkflowService::RecordActivityTaskHeartbeat_args
  def heartbeatRequest; end
  def heartbeatRequest=(value); end
  def heartbeatRequest?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::WorkflowService::RecordActivityTaskHeartbeat_result
  def badRequestError; end
  def badRequestError=(value); end
  def badRequestError?; end
  def clientVersionNotSupportedError; end
  def clientVersionNotSupportedError=(value); end
  def clientVersionNotSupportedError?; end
  def domainNotActiveError; end
  def domainNotActiveError=(value); end
  def domainNotActiveError?; end
  def entityNotExistError; end
  def entityNotExistError=(value); end
  def entityNotExistError?; end
  def internalServiceError; end
  def internalServiceError=(value); end
  def internalServiceError?; end
  def limitExceededError; end
  def limitExceededError=(value); end
  def limitExceededError?; end
  def serviceBusyError; end
  def serviceBusyError=(value); end
  def serviceBusyError?; end
  def struct_fields; end
  def success; end
  def success=(value); end
  def success?; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::WorkflowService::RecordActivityTaskHeartbeatByID_args
  def heartbeatRequest; end
  def heartbeatRequest=(value); end
  def heartbeatRequest?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::WorkflowService::RecordActivityTaskHeartbeatByID_result
  def badRequestError; end
  def badRequestError=(value); end
  def badRequestError?; end
  def clientVersionNotSupportedError; end
  def clientVersionNotSupportedError=(value); end
  def clientVersionNotSupportedError?; end
  def domainNotActiveError; end
  def domainNotActiveError=(value); end
  def domainNotActiveError?; end
  def entityNotExistError; end
  def entityNotExistError=(value); end
  def entityNotExistError?; end
  def internalServiceError; end
  def internalServiceError=(value); end
  def internalServiceError?; end
  def limitExceededError; end
  def limitExceededError=(value); end
  def limitExceededError?; end
  def serviceBusyError; end
  def serviceBusyError=(value); end
  def serviceBusyError?; end
  def struct_fields; end
  def success; end
  def success=(value); end
  def success?; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::WorkflowService::RespondActivityTaskCompleted_args
  def completeRequest; end
  def completeRequest=(value); end
  def completeRequest?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::WorkflowService::RespondActivityTaskCompleted_result
  def badRequestError; end
  def badRequestError=(value); end
  def badRequestError?; end
  def clientVersionNotSupportedError; end
  def clientVersionNotSupportedError=(value); end
  def clientVersionNotSupportedError?; end
  def domainNotActiveError; end
  def domainNotActiveError=(value); end
  def domainNotActiveError?; end
  def entityNotExistError; end
  def entityNotExistError=(value); end
  def entityNotExistError?; end
  def internalServiceError; end
  def internalServiceError=(value); end
  def internalServiceError?; end
  def limitExceededError; end
  def limitExceededError=(value); end
  def limitExceededError?; end
  def serviceBusyError; end
  def serviceBusyError=(value); end
  def serviceBusyError?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::WorkflowService::RespondActivityTaskCompletedByID_args
  def completeRequest; end
  def completeRequest=(value); end
  def completeRequest?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::WorkflowService::RespondActivityTaskCompletedByID_result
  def badRequestError; end
  def badRequestError=(value); end
  def badRequestError?; end
  def clientVersionNotSupportedError; end
  def clientVersionNotSupportedError=(value); end
  def clientVersionNotSupportedError?; end
  def domainNotActiveError; end
  def domainNotActiveError=(value); end
  def domainNotActiveError?; end
  def entityNotExistError; end
  def entityNotExistError=(value); end
  def entityNotExistError?; end
  def internalServiceError; end
  def internalServiceError=(value); end
  def internalServiceError?; end
  def limitExceededError; end
  def limitExceededError=(value); end
  def limitExceededError?; end
  def serviceBusyError; end
  def serviceBusyError=(value); end
  def serviceBusyError?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::WorkflowService::RespondActivityTaskFailed_args
  def failRequest; end
  def failRequest=(value); end
  def failRequest?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::WorkflowService::RespondActivityTaskFailed_result
  def badRequestError; end
  def badRequestError=(value); end
  def badRequestError?; end
  def clientVersionNotSupportedError; end
  def clientVersionNotSupportedError=(value); end
  def clientVersionNotSupportedError?; end
  def domainNotActiveError; end
  def domainNotActiveError=(value); end
  def domainNotActiveError?; end
  def entityNotExistError; end
  def entityNotExistError=(value); end
  def entityNotExistError?; end
  def internalServiceError; end
  def internalServiceError=(value); end
  def internalServiceError?; end
  def limitExceededError; end
  def limitExceededError=(value); end
  def limitExceededError?; end
  def serviceBusyError; end
  def serviceBusyError=(value); end
  def serviceBusyError?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::WorkflowService::RespondActivityTaskFailedByID_args
  def failRequest; end
  def failRequest=(value); end
  def failRequest?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::WorkflowService::RespondActivityTaskFailedByID_result
  def badRequestError; end
  def badRequestError=(value); end
  def badRequestError?; end
  def clientVersionNotSupportedError; end
  def clientVersionNotSupportedError=(value); end
  def clientVersionNotSupportedError?; end
  def domainNotActiveError; end
  def domainNotActiveError=(value); end
  def domainNotActiveError?; end
  def entityNotExistError; end
  def entityNotExistError=(value); end
  def entityNotExistError?; end
  def internalServiceError; end
  def internalServiceError=(value); end
  def internalServiceError?; end
  def limitExceededError; end
  def limitExceededError=(value); end
  def limitExceededError?; end
  def serviceBusyError; end
  def serviceBusyError=(value); end
  def serviceBusyError?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::WorkflowService::RespondActivityTaskCanceled_args
  def canceledRequest; end
  def canceledRequest=(value); end
  def canceledRequest?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::WorkflowService::RespondActivityTaskCanceled_result
  def badRequestError; end
  def badRequestError=(value); end
  def badRequestError?; end
  def clientVersionNotSupportedError; end
  def clientVersionNotSupportedError=(value); end
  def clientVersionNotSupportedError?; end
  def domainNotActiveError; end
  def domainNotActiveError=(value); end
  def domainNotActiveError?; end
  def entityNotExistError; end
  def entityNotExistError=(value); end
  def entityNotExistError?; end
  def internalServiceError; end
  def internalServiceError=(value); end
  def internalServiceError?; end
  def limitExceededError; end
  def limitExceededError=(value); end
  def limitExceededError?; end
  def serviceBusyError; end
  def serviceBusyError=(value); end
  def serviceBusyError?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::WorkflowService::RespondActivityTaskCanceledByID_args
  def canceledRequest; end
  def canceledRequest=(value); end
  def canceledRequest?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::WorkflowService::RespondActivityTaskCanceledByID_result
  def badRequestError; end
  def badRequestError=(value); end
  def badRequestError?; end
  def clientVersionNotSupportedError; end
  def clientVersionNotSupportedError=(value); end
  def clientVersionNotSupportedError?; end
  def domainNotActiveError; end
  def domainNotActiveError=(value); end
  def domainNotActiveError?; end
  def entityNotExistError; end
  def entityNotExistError=(value); end
  def entityNotExistError?; end
  def internalServiceError; end
  def internalServiceError=(value); end
  def internalServiceError?; end
  def limitExceededError; end
  def limitExceededError=(value); end
  def limitExceededError?; end
  def serviceBusyError; end
  def serviceBusyError=(value); end
  def serviceBusyError?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::WorkflowService::RequestCancelWorkflowExecution_args
  def cancelRequest; end
  def cancelRequest=(value); end
  def cancelRequest?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::WorkflowService::RequestCancelWorkflowExecution_result
  def badRequestError; end
  def badRequestError=(value); end
  def badRequestError?; end
  def cancellationAlreadyRequestedError; end
  def cancellationAlreadyRequestedError=(value); end
  def cancellationAlreadyRequestedError?; end
  def clientVersionNotSupportedError; end
  def clientVersionNotSupportedError=(value); end
  def clientVersionNotSupportedError?; end
  def domainNotActiveError; end
  def domainNotActiveError=(value); end
  def domainNotActiveError?; end
  def entityNotExistError; end
  def entityNotExistError=(value); end
  def entityNotExistError?; end
  def internalServiceError; end
  def internalServiceError=(value); end
  def internalServiceError?; end
  def limitExceededError; end
  def limitExceededError=(value); end
  def limitExceededError?; end
  def serviceBusyError; end
  def serviceBusyError=(value); end
  def serviceBusyError?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::WorkflowService::SignalWorkflowExecution_args
  def signalRequest; end
  def signalRequest=(value); end
  def signalRequest?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::WorkflowService::SignalWorkflowExecution_result
  def badRequestError; end
  def badRequestError=(value); end
  def badRequestError?; end
  def clientVersionNotSupportedError; end
  def clientVersionNotSupportedError=(value); end
  def clientVersionNotSupportedError?; end
  def domainNotActiveError; end
  def domainNotActiveError=(value); end
  def domainNotActiveError?; end
  def entityNotExistError; end
  def entityNotExistError=(value); end
  def entityNotExistError?; end
  def internalServiceError; end
  def internalServiceError=(value); end
  def internalServiceError?; end
  def limitExceededError; end
  def limitExceededError=(value); end
  def limitExceededError?; end
  def serviceBusyError; end
  def serviceBusyError=(value); end
  def serviceBusyError?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::WorkflowService::SignalWithStartWorkflowExecution_args
  def signalWithStartRequest; end
  def signalWithStartRequest=(value); end
  def signalWithStartRequest?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::WorkflowService::SignalWithStartWorkflowExecution_result
  def badRequestError; end
  def badRequestError=(value); end
  def badRequestError?; end
  def clientVersionNotSupportedError; end
  def clientVersionNotSupportedError=(value); end
  def clientVersionNotSupportedError?; end
  def domainNotActiveError; end
  def domainNotActiveError=(value); end
  def domainNotActiveError?; end
  def entityNotExistError; end
  def entityNotExistError=(value); end
  def entityNotExistError?; end
  def internalServiceError; end
  def internalServiceError=(value); end
  def internalServiceError?; end
  def limitExceededError; end
  def limitExceededError=(value); end
  def limitExceededError?; end
  def serviceBusyError; end
  def serviceBusyError=(value); end
  def serviceBusyError?; end
  def struct_fields; end
  def success; end
  def success=(value); end
  def success?; end
  def validate; end
  def workflowAlreadyStartedError; end
  def workflowAlreadyStartedError=(value); end
  def workflowAlreadyStartedError?; end
  include Thrift::Struct
end
class CadenceThrift::WorkflowService::ResetWorkflowExecution_args
  def resetRequest; end
  def resetRequest=(value); end
  def resetRequest?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::WorkflowService::ResetWorkflowExecution_result
  def badRequestError; end
  def badRequestError=(value); end
  def badRequestError?; end
  def clientVersionNotSupportedError; end
  def clientVersionNotSupportedError=(value); end
  def clientVersionNotSupportedError?; end
  def domainNotActiveError; end
  def domainNotActiveError=(value); end
  def domainNotActiveError?; end
  def entityNotExistError; end
  def entityNotExistError=(value); end
  def entityNotExistError?; end
  def internalServiceError; end
  def internalServiceError=(value); end
  def internalServiceError?; end
  def limitExceededError; end
  def limitExceededError=(value); end
  def limitExceededError?; end
  def serviceBusyError; end
  def serviceBusyError=(value); end
  def serviceBusyError?; end
  def struct_fields; end
  def success; end
  def success=(value); end
  def success?; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::WorkflowService::TerminateWorkflowExecution_args
  def struct_fields; end
  def terminateRequest; end
  def terminateRequest=(value); end
  def terminateRequest?; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::WorkflowService::TerminateWorkflowExecution_result
  def badRequestError; end
  def badRequestError=(value); end
  def badRequestError?; end
  def clientVersionNotSupportedError; end
  def clientVersionNotSupportedError=(value); end
  def clientVersionNotSupportedError?; end
  def domainNotActiveError; end
  def domainNotActiveError=(value); end
  def domainNotActiveError?; end
  def entityNotExistError; end
  def entityNotExistError=(value); end
  def entityNotExistError?; end
  def internalServiceError; end
  def internalServiceError=(value); end
  def internalServiceError?; end
  def limitExceededError; end
  def limitExceededError=(value); end
  def limitExceededError?; end
  def serviceBusyError; end
  def serviceBusyError=(value); end
  def serviceBusyError?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::WorkflowService::ListOpenWorkflowExecutions_args
  def listRequest; end
  def listRequest=(value); end
  def listRequest?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::WorkflowService::ListOpenWorkflowExecutions_result
  def badRequestError; end
  def badRequestError=(value); end
  def badRequestError?; end
  def clientVersionNotSupportedError; end
  def clientVersionNotSupportedError=(value); end
  def clientVersionNotSupportedError?; end
  def entityNotExistError; end
  def entityNotExistError=(value); end
  def entityNotExistError?; end
  def internalServiceError; end
  def internalServiceError=(value); end
  def internalServiceError?; end
  def limitExceededError; end
  def limitExceededError=(value); end
  def limitExceededError?; end
  def serviceBusyError; end
  def serviceBusyError=(value); end
  def serviceBusyError?; end
  def struct_fields; end
  def success; end
  def success=(value); end
  def success?; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::WorkflowService::ListClosedWorkflowExecutions_args
  def listRequest; end
  def listRequest=(value); end
  def listRequest?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::WorkflowService::ListClosedWorkflowExecutions_result
  def badRequestError; end
  def badRequestError=(value); end
  def badRequestError?; end
  def clientVersionNotSupportedError; end
  def clientVersionNotSupportedError=(value); end
  def clientVersionNotSupportedError?; end
  def entityNotExistError; end
  def entityNotExistError=(value); end
  def entityNotExistError?; end
  def internalServiceError; end
  def internalServiceError=(value); end
  def internalServiceError?; end
  def serviceBusyError; end
  def serviceBusyError=(value); end
  def serviceBusyError?; end
  def struct_fields; end
  def success; end
  def success=(value); end
  def success?; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::WorkflowService::ListWorkflowExecutions_args
  def listRequest; end
  def listRequest=(value); end
  def listRequest?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::WorkflowService::ListWorkflowExecutions_result
  def badRequestError; end
  def badRequestError=(value); end
  def badRequestError?; end
  def clientVersionNotSupportedError; end
  def clientVersionNotSupportedError=(value); end
  def clientVersionNotSupportedError?; end
  def entityNotExistError; end
  def entityNotExistError=(value); end
  def entityNotExistError?; end
  def internalServiceError; end
  def internalServiceError=(value); end
  def internalServiceError?; end
  def serviceBusyError; end
  def serviceBusyError=(value); end
  def serviceBusyError?; end
  def struct_fields; end
  def success; end
  def success=(value); end
  def success?; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::WorkflowService::ListArchivedWorkflowExecutions_args
  def listRequest; end
  def listRequest=(value); end
  def listRequest?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::WorkflowService::ListArchivedWorkflowExecutions_result
  def badRequestError; end
  def badRequestError=(value); end
  def badRequestError?; end
  def clientVersionNotSupportedError; end
  def clientVersionNotSupportedError=(value); end
  def clientVersionNotSupportedError?; end
  def entityNotExistError; end
  def entityNotExistError=(value); end
  def entityNotExistError?; end
  def internalServiceError; end
  def internalServiceError=(value); end
  def internalServiceError?; end
  def serviceBusyError; end
  def serviceBusyError=(value); end
  def serviceBusyError?; end
  def struct_fields; end
  def success; end
  def success=(value); end
  def success?; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::WorkflowService::ScanWorkflowExecutions_args
  def listRequest; end
  def listRequest=(value); end
  def listRequest?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::WorkflowService::ScanWorkflowExecutions_result
  def badRequestError; end
  def badRequestError=(value); end
  def badRequestError?; end
  def clientVersionNotSupportedError; end
  def clientVersionNotSupportedError=(value); end
  def clientVersionNotSupportedError?; end
  def entityNotExistError; end
  def entityNotExistError=(value); end
  def entityNotExistError?; end
  def internalServiceError; end
  def internalServiceError=(value); end
  def internalServiceError?; end
  def serviceBusyError; end
  def serviceBusyError=(value); end
  def serviceBusyError?; end
  def struct_fields; end
  def success; end
  def success=(value); end
  def success?; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::WorkflowService::CountWorkflowExecutions_args
  def countRequest; end
  def countRequest=(value); end
  def countRequest?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::WorkflowService::CountWorkflowExecutions_result
  def badRequestError; end
  def badRequestError=(value); end
  def badRequestError?; end
  def clientVersionNotSupportedError; end
  def clientVersionNotSupportedError=(value); end
  def clientVersionNotSupportedError?; end
  def entityNotExistError; end
  def entityNotExistError=(value); end
  def entityNotExistError?; end
  def internalServiceError; end
  def internalServiceError=(value); end
  def internalServiceError?; end
  def serviceBusyError; end
  def serviceBusyError=(value); end
  def serviceBusyError?; end
  def struct_fields; end
  def success; end
  def success=(value); end
  def success?; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::WorkflowService::GetSearchAttributes_args
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::WorkflowService::GetSearchAttributes_result
  def clientVersionNotSupportedError; end
  def clientVersionNotSupportedError=(value); end
  def clientVersionNotSupportedError?; end
  def internalServiceError; end
  def internalServiceError=(value); end
  def internalServiceError?; end
  def serviceBusyError; end
  def serviceBusyError=(value); end
  def serviceBusyError?; end
  def struct_fields; end
  def success; end
  def success=(value); end
  def success?; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::WorkflowService::RespondQueryTaskCompleted_args
  def completeRequest; end
  def completeRequest=(value); end
  def completeRequest?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::WorkflowService::RespondQueryTaskCompleted_result
  def badRequestError; end
  def badRequestError=(value); end
  def badRequestError?; end
  def clientVersionNotSupportedError; end
  def clientVersionNotSupportedError=(value); end
  def clientVersionNotSupportedError?; end
  def domainNotActiveError; end
  def domainNotActiveError=(value); end
  def domainNotActiveError?; end
  def entityNotExistError; end
  def entityNotExistError=(value); end
  def entityNotExistError?; end
  def internalServiceError; end
  def internalServiceError=(value); end
  def internalServiceError?; end
  def limitExceededError; end
  def limitExceededError=(value); end
  def limitExceededError?; end
  def serviceBusyError; end
  def serviceBusyError=(value); end
  def serviceBusyError?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::WorkflowService::ResetStickyTaskList_args
  def resetRequest; end
  def resetRequest=(value); end
  def resetRequest?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::WorkflowService::ResetStickyTaskList_result
  def badRequestError; end
  def badRequestError=(value); end
  def badRequestError?; end
  def clientVersionNotSupportedError; end
  def clientVersionNotSupportedError=(value); end
  def clientVersionNotSupportedError?; end
  def domainNotActiveError; end
  def domainNotActiveError=(value); end
  def domainNotActiveError?; end
  def entityNotExistError; end
  def entityNotExistError=(value); end
  def entityNotExistError?; end
  def internalServiceError; end
  def internalServiceError=(value); end
  def internalServiceError?; end
  def limitExceededError; end
  def limitExceededError=(value); end
  def limitExceededError?; end
  def serviceBusyError; end
  def serviceBusyError=(value); end
  def serviceBusyError?; end
  def struct_fields; end
  def success; end
  def success=(value); end
  def success?; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::WorkflowService::QueryWorkflow_args
  def queryRequest; end
  def queryRequest=(value); end
  def queryRequest?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::WorkflowService::QueryWorkflow_result
  def badRequestError; end
  def badRequestError=(value); end
  def badRequestError?; end
  def clientVersionNotSupportedError; end
  def clientVersionNotSupportedError=(value); end
  def clientVersionNotSupportedError?; end
  def entityNotExistError; end
  def entityNotExistError=(value); end
  def entityNotExistError?; end
  def internalServiceError; end
  def internalServiceError=(value); end
  def internalServiceError?; end
  def limitExceededError; end
  def limitExceededError=(value); end
  def limitExceededError?; end
  def queryFailedError; end
  def queryFailedError=(value); end
  def queryFailedError?; end
  def serviceBusyError; end
  def serviceBusyError=(value); end
  def serviceBusyError?; end
  def struct_fields; end
  def success; end
  def success=(value); end
  def success?; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::WorkflowService::DescribeWorkflowExecution_args
  def describeRequest; end
  def describeRequest=(value); end
  def describeRequest?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::WorkflowService::DescribeWorkflowExecution_result
  def badRequestError; end
  def badRequestError=(value); end
  def badRequestError?; end
  def clientVersionNotSupportedError; end
  def clientVersionNotSupportedError=(value); end
  def clientVersionNotSupportedError?; end
  def entityNotExistError; end
  def entityNotExistError=(value); end
  def entityNotExistError?; end
  def internalServiceError; end
  def internalServiceError=(value); end
  def internalServiceError?; end
  def limitExceededError; end
  def limitExceededError=(value); end
  def limitExceededError?; end
  def serviceBusyError; end
  def serviceBusyError=(value); end
  def serviceBusyError?; end
  def struct_fields; end
  def success; end
  def success=(value); end
  def success?; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::WorkflowService::DescribeTaskList_args
  def request; end
  def request=(value); end
  def request?; end
  def struct_fields; end
  def validate; end
  include Thrift::Struct
end
class CadenceThrift::WorkflowService::DescribeTaskList_result
  def badRequestError; end
  def badRequestError=(value); end
  def badRequestError?; end
  def clientVersionNotSupportedError; end
  def clientVersionNotSupportedError=(value); end
  def clientVersionNotSupportedError?; end
  def entityNotExistError; end
  def entityNotExistError=(value); end
  def entityNotExistError?; end
  def internalServiceError; end
  def internalServiceError=(value); end
  def internalServiceError?; end
  def limitExceededError; end
  def limitExceededError=(value); end
  def limitExceededError?; end
  def serviceBusyError; end
  def serviceBusyError=(value); end
  def serviceBusyError?; end
  def struct_fields; end
  def success; end
  def success=(value); end
  def success?; end
  def validate; end
  include Thrift::Struct
end
class Cadence::Connection::Thrift
  def connection; end
  def count_workflow_executions; end
  def deprecate_domain(name:); end
  def describe_domain(name:); end
  def describe_task_list(domain:, task_list:); end
  def describe_workflow_execution(domain:, workflow_id:, run_id:); end
  def get_search_attributes; end
  def get_workflow_execution_history(domain:, workflow_id:, run_id:, next_page_token: nil); end
  def identity; end
  def initialize(host, port, identity, options = nil); end
  def list_archived_workflow_executions; end
  def list_closed_workflow_executions; end
  def list_domains(page_size:); end
  def list_open_workflow_executions; end
  def list_workflow_executions; end
  def mutex; end
  def options; end
  def poll_for_activity_task(domain:, task_list:); end
  def poll_for_decision_task(domain:, task_list:); end
  def query_workflow; end
  def record_activity_task_heartbeat(task_token:, details: nil); end
  def record_activity_task_heartbeat_by_id; end
  def register_domain(name:, description: nil, global: nil, metrics: nil, retention_period: nil); end
  def request_cancel_workflow_execution; end
  def reset_sticky_task_list; end
  def reset_workflow_execution(domain:, workflow_id:, run_id:, reason:, decision_task_event_id:); end
  def respond_activity_task_canceled(task_token:, details: nil); end
  def respond_activity_task_canceled_by_id; end
  def respond_activity_task_completed(task_token:, result:); end
  def respond_activity_task_completed_by_id(domain:, activity_id:, workflow_id:, run_id:, result:); end
  def respond_activity_task_failed(task_token:, reason:, details: nil); end
  def respond_activity_task_failed_by_id(domain:, activity_id:, workflow_id:, run_id:, reason:, details: nil); end
  def respond_decision_task_completed(task_token:, decisions:); end
  def respond_decision_task_failed(task_token:, cause:, details: nil); end
  def respond_query_task_completed; end
  def scan_workflow_executions; end
  def send_request(name, request); end
  def signal_with_start_workflow_execution; end
  def signal_workflow_execution(domain:, workflow_id:, run_id:, signal:, input: nil); end
  def start_workflow_execution(domain:, workflow_id:, workflow_name:, task_list:, execution_timeout:, task_timeout:, input: nil, workflow_id_reuse_policy: nil, headers: nil, cron_schedule: nil); end
  def terminate_workflow_execution(domain:, workflow_id:, run_id:, reason:, details: nil); end
  def transport; end
  def update_domain(name:, description:); end
  def url; end
end
module Cadence::ThreadLocalContext
  def self.get; end
  def self.set(context); end
end
class Cadence::Activity
  def activity; end
  def execute(*_args); end
  def initialize(context); end
  def logger; end
  def self.execute_in_context(context, input); end
  extend Cadence::Activity::WorkflowConvenienceMethods
  extend Cadence::Concerns::Executable
end
module Cadence::Activity::WorkflowConvenienceMethods
  def execute!(*input, **args); end
  def execute(*input, **args); end
  def execute_locally(*input, **args); end
end
class Cadence::Activity::AsyncToken
  def activity_id; end
  def domain; end
  def initialize(domain, activity_id, workflow_id, run_id); end
  def run_id; end
  def self.decode(token); end
  def self.encode(domain, activity_id, workflow_id, run_id); end
  def to_s; end
  def workflow_id; end
end
class Cadence::Workflow
  def execute; end
  def initialize(context); end
  def logger; end
  def self.execute_in_context(context, input); end
  def workflow; end
  extend Cadence::Concerns::Executable
  extend Cadence::Testing::WorkflowOverride
  extend Cadence::Workflow::ConvenienceMethods
end
module Cadence::Workflow::ConvenienceMethods
  def execute!(*input, **args); end
  def execute(*input, **args); end
end
module Cadence::Utils
  def self.time_from_nanos(timestamp); end
  def self.time_to_nanos(time); end
end
class Cadence::Workflow::History
  def command?(event); end
  def events; end
  def initialize(events); end
  def iterator; end
  def last_completed_decision_task; end
  def next_event; end
  def next_window; end
  def peek_event; end
end
class Cadence::Workflow::History::Event
  def attributes; end
  def decision_id; end
  def extract_attributes(raw_event); end
  def id; end
  def initialize(raw_event); end
  def timestamp; end
  def type; end
end
class Cadence::Workflow::History::Window
  def add(event); end
  def events; end
  def initialize; end
  def last_event_id; end
  def local_time; end
  def markers; end
  def replay?; end
end
class Anonymous_Struct_609 < Struct
  def close_time; end
  def close_time=(_); end
  def history_length; end
  def history_length=(_); end
  def run_id; end
  def run_id=(_); end
  def self.[](*arg0); end
  def self.inspect; end
  def self.members; end
  def self.new(*arg0); end
  def start_time; end
  def start_time=(_); end
  def status; end
  def status=(_); end
  def workflow; end
  def workflow=(_); end
  def workflow_id; end
  def workflow_id=(_); end
end
class Cadence::Workflow::ExecutionInfo < Anonymous_Struct_609
  def canceled?; end
  def completed?; end
  def continued_as_new?; end
  def failed?; end
  def running?; end
  def self.generate_from(response); end
  def terminated?; end
  def timed_out?; end
end
class Cadence::Client
  def complete_activity(async_token, result = nil); end
  def config; end
  def connection; end
  def fail_activity(async_token, error); end
  def fetch_workflow_execution_info(_domain, workflow_id, run_id); end
  def get_last_completed_decision_task(domain, workflow_id, run_id); end
  def get_workflow_history(domain:, workflow_id:, run_id:); end
  def initialize(config); end
  def register_domain(name, description = nil); end
  def reset_workflow(domain, workflow_id, run_id, decision_task_id: nil, reason: nil); end
  def schedule_workflow(workflow, cron_schedule, *input, **args); end
  def signal_workflow(workflow, signal, workflow_id, run_id, input = nil); end
  def start_workflow(workflow, *input, **args); end
  def terminate_workflow(domain, workflow_id, run_id, reason: nil, details: nil); end
end
class Cadence::Metrics
  def adapter; end
  def count(key, count, tags = nil); end
  def decrement(key, tags = nil); end
  def gauge(key, value, tags = nil); end
  def increment(key, tags = nil); end
  def initialize(adapter); end
  def timing(key, time, tags = nil); end
end
module Cadence::Saga
end
class Cadence::Saga::Saga
  def add_compensation(activity, *args); end
  def compensate; end
  def compensations; end
  def context; end
  def initialize(context); end
end
class Cadence::Saga::Result
  def compensated?; end
  def completed?; end
  def initialize(completed, rollback_reason = nil); end
  def rollback_reason; end
end
module Cadence::Saga::Concern
  def compensate?(error, compensate_on: nil, do_not_compensate_on: nil); end
  def run_saga(configuration = nil, &block); end
end
module Satellites
end
module Satellites::LedgerAccountMapper
end
module Cadence::Metadata
end
class Cadence::Metadata::Base
  def activity?; end
  def decision?; end
  def workflow?; end
end
class Cadence::Metadata::Activity < Cadence::Metadata::Base
  def activity?; end
  def attempt; end
  def domain; end
  def headers; end
  def id; end
  def initialize(domain:, id:, name:, task_token:, attempt:, workflow_run_id:, workflow_id:, workflow_name:, timeouts:, headers: nil); end
  def name; end
  def task_token; end
  def timeouts; end
  def workflow_id; end
  def workflow_name; end
  def workflow_run_id; end
end
module Cadence::Testing
  def self.disabled!(&block); end
  def self.disabled?; end
  def self.local!(&block); end
  def self.local?; end
  def self.mode; end
  def self.set_mode(new_mode, &block); end
  def self.with_mode(new_mode, &block); end
end
class Cadence::Testing::FutureRegistry
  def complete(token, result); end
  def fail(token, error); end
  def initialize; end
  def register(token, future); end
  def store; end
end
class Cadence::Testing::WorkflowExecution
  def complete_activity(token, result); end
  def fail_activity(token, error); end
  def fiber; end
  def futures; end
  def initialize; end
  def register_future(token, future); end
  def resume; end
  def run(&block); end
  def status; end
end
module Cadence::UUID
  def self.v5(uuid_namespace, name); end
end
class Cadence::Activity::Context
  def async; end
  def async?; end
  def async_token; end
  def connection; end
  def headers; end
  def heartbeat(details = nil); end
  def idem; end
  def initialize(connection, metadata); end
  def logger; end
  def metadata; end
  def run_idem; end
  def task_token; end
  def workflow_idem; end
end
class Cadence::Testing::LocalActivityContext < Cadence::Activity::Context
  def heartbeat(details = nil); end
  def initialize(metadata); end
end
class Cadence::Workflow::Future
  def callbacks; end
  def cancel; end
  def cancelation_id; end
  def context; end
  def done(&block); end
  def fail(reason, details); end
  def failed?; end
  def failure; end
  def finished?; end
  def get; end
  def initialize(target, context, cancelation_id: nil); end
  def ready?; end
  def result; end
  def set(result); end
  def target; end
  def wait; end
end
class Cadence::Workflow::History::EventTarget
  def ==(other); end
  def eql?(other); end
  def hash; end
  def id; end
  def initialize(id, type); end
  def self.from_event(event); end
  def self.workflow; end
  def to_s; end
  def type; end
end
class Cadence::Workflow::History::EventTarget::UnexpectedEventType < Cadence::InternalError
end
class Cadence::Testing::LocalWorkflowContext
  def cancel(target, cancelation_id); end
  def cancel_activity(activity_id); end
  def cancel_timer(timer_id); end
  def complete(result = nil); end
  def disabled_releases; end
  def execute_activity!(activity_class, *input, **args); end
  def execute_activity(activity_class, *input, **args); end
  def execute_local_activity(activity_class, *input, **args); end
  def execute_workflow!(workflow_class, *input, **args); end
  def execute_workflow(workflow_class, *input, **args); end
  def execution; end
  def fail(reason, details = nil); end
  def has_release?(change_name); end
  def headers; end
  def initialize(execution, workflow_id, run_id, disabled_releases, headers = nil); end
  def logger; end
  def next_event_id; end
  def now; end
  def on_signal(&block); end
  def run_id; end
  def safe_constantize(const); end
  def side_effect(&block); end
  def sleep(timeout); end
  def sleep_until(end_time); end
  def start_timer(timeout, timer_id = nil); end
  def wait_for(future); end
  def wait_for_all(*futures); end
  def workflow_id; end
end
module Cadence::Testing::CadenceOverride
  def allowed?(workflow_id, reuse_policy); end
  def complete_activity(async_token, result = nil); end
  def disallowed_statuses_for(reuse_policy); end
  def executions; end
  def fail_activity(async_token, error); end
  def fetch_workflow_execution_info(_domain, workflow_id, run_id); end
  def start_locally(workflow, *input, **args); end
  def start_workflow(workflow, *input, **args); end
end
module Cadence::Testing::WorkflowOverride
  def allow_all_releases; end
  def allow_release(release_name); end
  def disable_release(release_name); end
  def disabled_releases; end
  def execute_locally(*input); end
end
