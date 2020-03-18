require 'cadence/concerns/processor'

module Cadence
  class Middleware
    extend Concerns::Processor

    def initialize(app)
      @next = nil
      @prev = nil
    end

    def call(task, next_middleware)
      raise NotImplementedError, '#process method must be implemented by a subclass'
    end

  end
end
