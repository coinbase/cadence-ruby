module Fabrication
  module Generator
    class DataMapper < Fabrication::Generator::Base
      def self.supports?(klass)
        defined?(::DataMapper) && klass.ancestors.include?(::DataMapper::Hook)
      end

      def build_instance
        self._instance = resolved_class.new(_attributes)
      end

      protected

      def persist
        _instance.save
      end
    end
  end
end
