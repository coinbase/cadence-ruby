$LOAD_PATH.unshift __dir__

require 'bundler'
Bundler.require :default

require 'cadence'
require 'cadence/metrics_adapters/log'

metrics_logger = Logger.new(STDOUT, progname: 'metrics')

Cadence.configure do |config|
  config.host = ENV.fetch('CADENCE_HOST', 'localhost')
  config.port = ENV.fetch('CADENCE_PORT', 6666).to_i
  config.domain = ENV.fetch('CADENCE_DOMAIN', 'ruby-samples')
  config.task_list = ENV.fetch('CADENCE_TASK_LIST', 'general')
  config.metrics_adapter = Cadence::MetricsAdapters::Log.new(metrics_logger)
  config.on_error do |error, _metadata|
    puts "[ERROR HANDLER] #{error.inspect}"
  end
end
