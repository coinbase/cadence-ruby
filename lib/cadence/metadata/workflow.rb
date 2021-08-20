require 'cadence/metadata/base'

module Cadence
  module Metadata
    class Workflow < Base
      attr_reader :domain, :id, :name, :run_id, :attempt, :headers, :timeouts

      def initialize(domain:, id:, name:, run_id:, attempt:, timeouts:, headers: {})
        @domain = domain
        @id = id
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

      def to_h
        {
          domain: domain,
          workflow_id: id,
          workflow_name: name,
          workflow_run_id: run_id,
          attempt: attempt
        }
      end
    end
  end
end
