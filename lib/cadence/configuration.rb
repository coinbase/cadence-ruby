require 'logger'
require 'cadence/metrics_adapters/null'

module Cadence
  class Configuration
    Connection = Struct.new(:type, :host, :port, keyword_init: true)
    Execution = Struct.new(:domain, :task_list, :timeouts, :headers, keyword_init: true)

    attr_reader :timeouts, :error_handlers
    attr_accessor :connection_type, :host, :port, :logger, :metrics_adapter, :domain, :task_list, :headers

    DEFAULT_TIMEOUTS = {
      execution: 60,          # End-to-end workflow time
      task: 10,               # Decision task processing time
      schedule_to_close: nil, # End-to-end activity time (default: schedule_to_start + start_to_close)
      schedule_to_start: 10,  # Queue time for an activity
      start_to_close: 30,     # Time spent processing an activity
      heartbeat: nil          # Max time between heartbeats (off by default)
    }.freeze

    DEFAULT_HEADERS = {}.freeze
    DEFAULT_DOMAIN = 'default-domain'.freeze
    DEFAULT_TASK_LIST = 'default-task-list'.freeze

    def initialize
      @connection_type = :thrift
      @logger = Logger.new(STDOUT, progname: 'cadence_client')
      @metrics_adapter = MetricsAdapters::Null.new
      @timeouts = DEFAULT_TIMEOUTS
      @domain = DEFAULT_DOMAIN
      @task_list = DEFAULT_TASK_LIST
      @headers = DEFAULT_HEADERS
      @error_handlers = []
    end

    def timeouts=(new_timeouts)
      @timeouts = DEFAULT_TIMEOUTS.merge(new_timeouts)
    end

    def on_error(&block)
      @error_handlers << block
    end

    def for_connection
      Connection.new(
        type: connection_type,
        host: host,
        port: port
      ).freeze
    end

    def default_execution_options
      Execution.new(
        domain: domain,
        task_list: task_list,
        timeouts: timeouts,
        headers: headers
      ).freeze
    end
  end
end
