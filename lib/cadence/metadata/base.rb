module Cadence
  module Metadata
    class Base
      def activity?
        false
      end

      def decision?
        false
      end

      def workflow?
        false
      end

      def to_h
        raise NotImplementedError, 'Metadata::Base subclass is expected to have #to_h implemented'
      end
    end
  end
end
