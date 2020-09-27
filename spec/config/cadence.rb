require 'cadence'

Cadence.configure do |config|
  config.logger = Logger.new('/dev/null')
end
