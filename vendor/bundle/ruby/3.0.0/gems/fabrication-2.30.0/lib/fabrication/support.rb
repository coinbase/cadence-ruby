module Fabrication
  module Support
    extend self

    def fabricatable?(name)
      Fabrication.manager[name] || class_for(name)
    end

    def log_deprecation(message)
      Config.logger.warn("[DEPRECATION][fabrication] #{message}")
    end

    def class_for(class_or_to_s)
      constantize(variable_name_to_class_name(class_or_to_s))
    rescue NameError => e
      raise Fabrication::UnfabricatableError.new(class_or_to_s, e)
    end

    def constantize(camel_cased_word)
      return camel_cased_word if camel_cased_word.is_a?(Class)

      camel_cased_word.to_s.split('::').reduce(Object) do |resolved_class, class_part|
        resolved_class.const_get(class_part)
      end
    end

    def extract_options!(args)
      args.last.is_a?(::Hash) ? args.pop : {}
    end

    def variable_name_to_class_name(name)
      name_string = name.to_s

      if name_string.respond_to?(:camelize)
        name_string.camelize
      else
        name_string
          .gsub(%r{/(.?)}) { "::#{Regexp.last_match(1).upcase}" }
          .gsub(/(?:^|_)(.)/) { Regexp.last_match(1).upcase }
      end
    end

    def find_definitions
      log_deprecation('Fabrication::Support.find_definitions has been replaced by ' \
                      'Fabrication.manager.load_definitions and will be removed in 3.0.0.')

      Fabrication.manager.load_definitions
    end

    def hash_class
      @hash_class ||= defined?(HashWithIndifferentAccess) ? HashWithIndifferentAccess : Hash
    end

    def singularize(string)
      string.singularize
    rescue StandardError
      string.end_with?('s') ? string[0..-2] : string
    end

    def underscore(string)
      string.gsub(/::/, '/')
            .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
            .gsub(/([a-z\d])([A-Z])/, '\1_\2')
            .tr('-', '_')
            .downcase
    end
  end
end
