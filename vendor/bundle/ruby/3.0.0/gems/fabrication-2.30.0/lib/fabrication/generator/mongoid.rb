module Fabrication
  module Generator
    class Mongoid < Fabrication::Generator::Base
      def self.supports?(klass)
        defined?(::Mongoid) && klass.ancestors.include?(::Mongoid::Document)
      end

      def build_instance
        self._instance = if resolved_class.respond_to?(:protected_attributes)
                           resolved_class.new(_attributes, without_protection: true)
                         else
                           resolved_class.new(_attributes)
                         end
      end
    end
  end
end
