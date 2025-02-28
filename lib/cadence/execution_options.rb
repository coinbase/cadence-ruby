require 'cadence/concerns/executable'
require 'cadence/concerns/versioned'
require 'cadence/retry_policy'

module Cadence
  class ExecutionOptions
    attr_reader :name, :domain, :task_list, :retry_policy, :timeouts, :headers

    def initialize(object, options, defaults = nil)
      # Options are treated as overrides and take precedence
      @name = options[:name] || object.to_s
      @domain = options[:domain]
      @task_list = options[:task_list]
      @retry_policy = options[:retry_policy] || {}
      @cron_schedule = options[:cron_schedule]
      @timeouts = options[:timeouts] || {}
      @headers = options[:headers] || {}

      # For Cadence::Workflow and Cadence::Activity use defined values as the next option
      if object.singleton_class.included_modules.include?(Concerns::Executable)
        # In a versioned workflow merge the specific version options with default workflow options
        object = Concerns::Versioned::Workflow.new(object, options[:version]) if versioned?(object)

        @domain ||= object.domain
        @task_list ||= object.task_list
        @retry_policy = object.retry_policy.merge(@retry_policy) if object.retry_policy
        @timeouts = object.timeouts.merge(@timeouts) if object.timeouts
        @headers = object.headers.merge(@headers) if object.headers
      end

      # Lastly consider defaults if they are given
      if defaults
        @domain ||= defaults.domain
        @task_list ||= defaults.task_list
        @timeouts = defaults.timeouts.merge(@timeouts)
        @headers = defaults.headers.merge(@headers)
      end

      if @retry_policy.empty?
        @retry_policy = nil
      else
        @retry_policy = Cadence::RetryPolicy.new(@retry_policy)
        @retry_policy.validate!
      end

      freeze
    end

    private

    def versioned?(workflow)
      workflow.singleton_class.included_modules.include?(Concerns::Versioned::ClassMethods)
    end
  end
end
