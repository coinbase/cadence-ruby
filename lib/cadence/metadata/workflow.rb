require 'cadence/metadata/base'

module Cadence
  module Metadata
    class Workflow < Base
      attr_reader :name, :run_id, :attempt, :headers, :timeouts

      def initialize(name:, run_id:, attempt:, timeouts:, headers: {})
        @name = name
        @run_id = run_id
        @attempt = attempt
        @headers = headers
        @timeouts = timeouts

        freeze
      end

      def workflow?
        true
      end
    end
  end
end
