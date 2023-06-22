require 'singleton'

module Fabrication
  class Transform
    include Singleton

    class << self
      def apply_to(schematic, attributes_hash)
        Fabrication.manager.load_definitions if Fabrication.manager.empty?
        attributes_hash.inject({}) { |h, (k, v)| h.update(k => instance.apply_transform(schematic, k, v)) }
      end

      def clear_all
        instance.transforms.clear
        instance.overrides.clear
      end

      def define(attribute, transform)
        instance.transforms[attribute] = transform
      end

      def only_for(schematic, attribute, transform)
        instance.overrides[schematic] = (instance.overrides[schematic] || {}).merge!(attribute => transform)
      end
    end

    def overrides
      @overrides ||= {}
    end

    def apply_transform(schematic, attribute, value)
      overrides.fetch(schematic, transforms)[attribute].call(value)
    end

    def transforms
      @transforms ||= Hash.new(->(value) { value })
    end
  end
end
