require 'cadence/retry_policy'

module Cadence
  module Concerns
    module Processor
      def process
        raise NotImplementedError, '#process method must be implemented by a subclass'
      end
    end
  end
end
