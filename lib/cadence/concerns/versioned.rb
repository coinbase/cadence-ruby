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
        attr_reader :version, :main_class, :version_class

        def initialize(main_class, version = nil)
          version ||= main_class.pick_version
          version_class = main_class.version_class_for(version)

          @version = version
          @main_class = main_class
          @version_class = version_class
        end

        def domain
          if version_class.domain
            warn '[WARNING] Overriding domain in a workflow version is not yet supported. ' \
                 "Called from #{version_class}."
          end

          main_class.domain
        end

        def task_list
          if version_class.task_list
            warn '[WARNING] Overriding task_list in a workflow version is not yet supported. ' \
                 "Called from #{version_class}."
          end

          main_class.task_list
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

        def pick_version
          version_picker.call(versions.keys.max)
        end

        private

        DEFAULT_VERSION_PICKER = lambda { |latest_version| latest_version }

        def version_picker(&block)
          return @version_picker || DEFAULT_VERSION_PICKER unless block_given?
          @version_picker = block
        end

        def versions
          # Initialize with the default version
          @versions ||= { DEFAULT_VERSION => self }
        end
      end
    end
  end
end
