require 'cadence/errors'

module Cadence
  module Concerns
    module Versioned
      def self.included(base)
        base.extend ClassMethods
      end

      VERSION_HEADER_NAME = 'Version'.freeze
      DEFAULT_VERSION = 0

      class UnknownWorkflowVersion < Cadence::ClientError; end

      class Workflow
        def initialize(main_class, headers)
          version = headers.fetch(VERSION_HEADER_NAME, main_class.latest_version).to_i
          version_class = main_class.version_class_for(version)

          @version = version
          @main_class = main_class
          @version_class = version_class
        end

        def domain
          version_class.domain || main_class.domain
        end

        def task_list
          version_class.task_list || main_class.task_list
        end

        def retry_policy
          version_class.retry_policy || main_class.retry_policy
        end

        def timeouts
          version_class.timeouts || main_class.timeouts
        end

        def headers
          (version_class.headers || main_class.headers || {}).merge(VERSION_HEADER_NAME => version.to_s)
        end

        private

        attr_reader :version, :main_class, :version_class
      end

      module ClassMethods
        def version(number, workflow_class)
          versions[number] = workflow_class
        end

        def execute_in_context(context, input)
          version = context.headers.fetch(VERSION_HEADER_NAME, DEFAULT_VERSION).to_i
          version_class = version_class_for(version)

          if self == version_class
            super
          else
            # forward the method call to the target version class
            version_class.execute_in_context(context, input)
          end
        end

        def version_class_for(version)
          versions.fetch(version.to_i) do
            raise UnknownWorkflowVersion, "Unknown version #{version} for #{self.name}"
          end
        end

        def latest_version
          versions.keys.max
        end

        private

        def versions
          # Initialize with the default version
          @versions ||= { DEFAULT_VERSION => self }
        end
      end
    end
  end
end
