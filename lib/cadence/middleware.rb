module Cadence
  class Middleware

    def call(task, &next_middleware)
      raise NotImplementedError, '#call method must be implemented by a subclass'
    end

  end
end
