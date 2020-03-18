module Cadence
  class Middleware

    def initialize(next)
      @next = next
    end

    def call(task)
      raise NotImplementedError, '#process method must be implemented by a subclass'
    end

  end
end
