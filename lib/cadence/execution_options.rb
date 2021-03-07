require 'cadence/concerns/executable'

module Cadence
  class ExecutionOptions
    attr_reader :name, :domain, :task_list, :retry_policy, :timeouts, :headers

    def initialize(object, options, defaults = nil)
      @name = options[:name] || object.to_s
      @domain = options[:domain]
      @task_list = options[:task_list]
      @retry_policy = options[:retry_policy]
      @cron_schedule = options[:cron_schedule]
      @timeouts = options[:timeouts] || {}
      @headers = options[:headers] || {}

      if object.singleton_class.included_modules.include?(Concerns::Executable)
        @domain ||= object.domain
        @task_list ||= object.task_list
        @retry_policy ||= object.retry_policy
        @timeouts = object.timeouts.merge(@timeouts) if object.timeouts
        @headers = object.headers.merge(@headers) if object.headers
      end

      if defaults
        @domain ||= defaults.domain
        @task_list ||= defaults.task_list
        @timeouts = defaults.timeouts.merge(@timeouts)
        @headers = defaults.headers.merge(@headers)
      end

      freeze
    end
  end
end
