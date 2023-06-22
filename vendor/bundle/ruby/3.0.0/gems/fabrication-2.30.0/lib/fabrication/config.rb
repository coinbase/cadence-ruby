require 'logger'

module Fabrication
  module Config
    extend self

    def configure
      yield self
    end

    def reset_defaults
      @fabricator_path =
        @path_prefix =
          @sequence_start =
            @generators =
              nil
    end

    attr_writer :logger, :sequence_start

    def logger
      @logger ||= Logger.new($stdout).tap do |logger|
        logger.level = Logger::WARN
      end
    end

    def fabricator_path
      @fabricator_path ||= ['test/fabricators', 'spec/fabricators']
    end
    alias fabricator_paths fabricator_path

    def fabricator_dir
      Support.log_deprecation('Fabrication::Config.fabricator_dir has been ' \
                              'replaced by Fabrication::Config.fabricator_path')
      fabricator_path
    end

    def fabricator_path=(folders)
      @fabricator_path = ([] << folders).flatten
    end

    def fabricator_dir=(folders)
      Support.log_deprecation('Fabrication::Config.fabricator_dir has been ' \
                              'replaced by Fabrication::Config.fabricator_path')
      self.fabricator_path = folders
    end

    def sequence_start
      @sequence_start ||= 0
    end

    def path_prefix=(folders)
      @path_prefix = ([] << folders).flatten
    end

    def path_prefix
      @path_prefix ||= [defined?(Rails) ? Rails.root : '.']
    end
    alias path_prefixes path_prefix

    def generators
      @generators ||= []
    end

    def generator_for(default_generators, klass)
      (generators + default_generators).detect { |gen| gen.supports?(klass) }
    end

    def recursion_limit
      @recursion_limit ||= 20
    end

    def recursion_limit=(limit)
      @recursion_limit = limit
    end

    def register_with_steps=(value)
      Support.log_deprecation(
        'Fabrication::Config.register_with_steps has been deprecated. ' \
        'Please regenerate your cucumber steps with `rails g fabrication:cucumber_steps'
      )

      return unless value

      register_notifier do |name, object|
        Fabrication::Cucumber::Fabrications[name] = object
      end
    end

    def notifiers
      @notifiers ||= []
    end

    def register_notifier(&block)
      notifiers.push(block)
    end
  end
end
