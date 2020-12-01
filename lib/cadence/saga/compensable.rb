
module Cadence
  module Saga
    module Compensable
      def compensable_errors(*args)
        return @compensable_errors if args.empty?
        @compensable_errors = args.first
      end

      def non_compensable_errors(*args)
        return @non_compensable_errors if args.empty?
        @non_compensable_errors = args.first
      end

      def compensable?(error)
        error_class = error.class
        (compensable_errors.nil? && non_compensable_errors.nil?) || 
          (compensable_errors&.include?(error_class) || 
            non_compensable_errors && !non_compensable_errors.include?(error_class))
      end
    end
  end
end
