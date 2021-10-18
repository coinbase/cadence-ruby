require 'securerandom'
require 'forwardable'
require 'cadence/configuration'
require 'cadence/client'
require 'cadence/metrics'

module Cadence
  extend SingleForwardable

  def_delegators :default_client, # target
                 :start_workflow,
                 :schedule_workflow,
                 :register_domain,
                 :signal_workflow,
                 :reset_workflow,
                 :terminate_workflow,
                 :fetch_workflow_execution_info,
                 :complete_activity,
                 :fail_activity,
                 :get_workflow_history,
                 :list_open_workflow_executions,
                 :list_closed_workflow_executions

  class << self
    def configure(&block)
      yield config
    end

    def configuration
      warn '[DEPRECATION] This method is now deprecated without a substitution'
      config
    end

    def logger
      config.logger
    end

    def metrics
      @metrics ||= Metrics.new(config.metrics_adapter)
    end

    private

    def default_client
      @default_client ||= Client.new(config)
    end

    def config
      @config ||= Configuration.new
    end
  end
end
