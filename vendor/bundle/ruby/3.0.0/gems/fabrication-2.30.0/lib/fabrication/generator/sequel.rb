module Fabrication
  module Generator
    class Sequel < Fabrication::Generator::Base
      def initialize(klass)
        super
        load_instance_hooks
      end

      def self.supports?(klass)
        defined?(::Sequel) && defined?(::Sequel::Model) && klass.ancestors.include?(::Sequel::Model)
      end

      def set_attributes
        _attributes.each do |field_name, value|
          if value.is_a?(Array) && (association = association_for(field_name))
            set_association(association, field_name, value)
          else
            set_attribute(field_name, value)
          end
        end
      end

      def persist
        _instance.save(raise_on_failure: true)
      end

      private

      def association_for(field_name)
        resolved_class.association_reflections[field_name]
      end

      def set_attribute(field_name, value)
        _instance.send("#{field_name}=", value)
      end

      def set_association(association, field_name, value)
        _instance.associations[field_name] = value
        _instance.after_save_hook do
          value.each { |o| _instance.send(association.add_method, o) }
        end
      end

      def load_instance_hooks
        klass = resolved_class.respond_to?(:cti_base_model) ? resolved_class.cti_models.first : resolved_class
        klass.plugin :instance_hooks unless klass.new.respond_to? :after_save_hook
      end
    end
  end
end
