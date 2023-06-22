module Fabrication
  module Generator
    class Base
      def self.supports?(_resolved_class)
        true
      end

      def build(attributes = [], callbacks = {})
        process_attributes(attributes)

        if callbacks[:initialize_with]
          build_instance_with_constructor_override(callbacks[:initialize_with])
        elsif callbacks[:on_init]
          Fabrication::Support.log_deprecation(
            'The on_init callback has been replaced by initialize_with. Please see the documentation for usage'
          )
          build_instance_with_init_callback(callbacks[:on_init])
        else
          build_instance
        end
        execute_callbacks(callbacks[:after_build])
        _instance
      end

      def create(attributes = [], callbacks = {})
        build(attributes, callbacks)
        execute_deprecated_callbacks(callbacks, :before_validation, :before_create)
        execute_deprecated_callbacks(callbacks, :after_validation, :before_create)
        execute_deprecated_callbacks(callbacks, :before_save, :before_create)
        execute_callbacks(callbacks[:before_create])
        persist
        execute_callbacks(callbacks[:after_create])
        execute_deprecated_callbacks(callbacks, :after_save, :after_create)
        _instance
      end

      def execute_deprecated_callbacks(callbacks, callback_type, replacement_callback)
        if callbacks[callback_type]
          Fabrication::Support.log_deprecation(
            "Using #{callback_type} is deprecated but you can replace it " \
            "with #{replacement_callback} with the same result."
          )
        end

        execute_callbacks(callbacks[callback_type])
      end

      def execute_callbacks(callbacks)
        callbacks&.each { |callback| _instance.instance_exec(_instance, _transient_attributes, &callback) }
      end

      def to_params(attributes = [])
        process_attributes(attributes)
        _attributes.respond_to?(:with_indifferent_access) ? _attributes.with_indifferent_access : _attributes
      end

      def to_hash(attributes = [], _callbacks = [])
        process_attributes(attributes)
        Fabrication::Support.hash_class.new.tap do |hash|
          _attributes.map do |name, value|
            if value.respond_to?(:id)
              hash["#{name}_id"] = value.id
            else
              hash[name] = value
            end
          end
        end
      end

      def build_instance_with_constructor_override(callback)
        self._instance = instance_exec(_transient_attributes, &callback)
        set_attributes
      end

      def build_instance_with_init_callback(callback)
        self._instance = resolved_class.new(*callback.call(_transient_attributes))
        set_attributes
      end

      def build_instance
        self._instance = resolved_class.new
        set_attributes
      end

      def set_attributes
        _attributes.each do |k, v|
          _instance.send("#{k}=", v)
        end
      end

      def initialize(resolved_class)
        self.resolved_class = resolved_class
      end

      def respond_to_missing?(method_name, _include_private = false)
        _attributes.key?(method_name)
      end

      def method_missing(method_name, *args, &block)
        _attributes.fetch(method_name) { super }
      end

      def _klass
        Fabrication::Support.log_deprecation(
          'The `_klass` method in fabricator definitions has been replaced by `resolved_class`'
        )

        resolved_class
      end

      protected

      attr_accessor :resolved_class, :_instance

      def _attributes
        @_attributes ||= {}
      end

      def _transient_attributes
        @_transient_attributes ||= {}
      end

      def persist
        _instance.save! if _instance.respond_to?(:save!)
      end

      def process_attributes(attributes)
        attributes.each do |attribute|
          _attributes[attribute.name] = attribute.processed_value(_attributes)
          _transient_attributes[attribute.name] = _attributes[attribute.name] if attribute.transient?
        end
        _attributes.reject! { |k| _transient_attributes.key?(k) }
      end
    end
  end
end
