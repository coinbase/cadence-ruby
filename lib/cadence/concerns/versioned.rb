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

      module ClassMethods
        def execute_in_context(context, input)
          target_version = context.headers[VERSION_HEADER_NAME].to_i
          workflow_class = version_class_for(target_version)

          if !workflow_class
            raise UnknownWorkflowVersion, "Unknown version #{target_version} for #{self.name}"
          end

          super
        end

        def version(number, workflow_class)
          versions[number] = workflow_class
        end

        def domain(*args)
          return version_class_for(latest_version).domain || @domain if args.empty?
          @domain = args.first
        end

        def task_list(*args)
          return version_class_for(latest_version).task_list || @task_list if args.empty?
          @task_list = args.first
        end

        def retry_policy(*args)
          return version_class_for(latest_version).retry_policy || @retry_policy if args.empty?
          @retry_policy = Cadence::RetryPolicy.new(args.first)
          @retry_policy.validate!
        end

        def timeouts(*args)
          return version_class_for(latest_version).timeouts || @timeouts if args.empty?
          @timeouts = args.first
        end

        def headers(*args)
          if args.empty?
            headers = version_class_for(latest_version).headers || @headers

            if headers.key?(VERSION_HEADER_NAME)
              warn "[WARNING] #{VERSION_HEADER_NAME} header collision"
            end

            return headers.merge(VERSION_HEADER_NAME => latest_version.to_s)
          end

          super
        end

        def new(context)
          target_version = context.headers[VERSION_HEADER_NAME].to_i
          workflow_class = version_class_for(target_version)

          # Swap top-level class with version-specific class
          workflow_class.new(context)
        end

        private

        def versions
          # Initialize with the default version
          @versions ||= { DEFAULT_VERSION => self }
        end

        def version_class_for(version)
          versions[version]
        end

        def latest_version
          versions.keys.max
        end
      end
    end
  end
end
