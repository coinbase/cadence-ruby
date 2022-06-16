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

class Cadence::Worker
end

class Cadence::Crew
    def after_fork(block); end

    def dispatch; end

    def stop(signal); end
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

class Cadence::Client::Error < Cadence::Error
end

class Cadence::Client::ArgumentError < Cadence::Error
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

  def initialize(domain:, id:, name:, task_token:, attempt:, workflow_run_id:, workflow_id:, workflow_name:, timeouts:, headers: nil)
  end

  def name; end

  def task_token; end

  def timeouts; end

  def workflow_id; end

  def workflow_name; end

  def workflow_run_id; end
end

class Cadence::Metadata::Decision < Cadence::Metadata::Base
end

class Cadence::Metadata::Workflow < Cadence::Metadata::Base
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

module CadenceThrift
  class BadRequestError; end

  class InternalServiceError; end

  class DomainAlreadyExistsError; end

  class WorkflowExecutionAlreadyStartedError; end

  class EntityNotExistsError; end

  class ServiceBusyError; end

  class CancellationAlreadyRequestedError; end

  class QueryFailedError; end

  class DomainNotActiveError; end

  class LimitExceededError; end

  class AccessDeniedError; end

  class RetryTaskError; end

  class ClientVersionNotSupportedError; end
end
