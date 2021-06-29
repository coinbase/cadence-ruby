RSpec.configure do |config|
  config.before(:each) do
    Cadence.configuration.error_handlers.clear
  end
end
