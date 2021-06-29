module Cadence
  module ErrorHandler
    def self.handle(error, metadata: nil)
      Cadence.configuration.error_handlers.each do |handler|
        handler.call(error, metadata)
      rescue StandardError => e
        Cadence.logger.error("Error handler failed: #{e.inspect}")
      end
    end
  end
end
