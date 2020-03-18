require 'cadence/middleware'

class LoggingMiddleware < Cadence::Middleware

  def call(task, &next_middleware)
    Cadence.logger.info(task)
    return next_middleware.call(task)
  end

end