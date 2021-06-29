class LoggingMiddleware
  def initialize(app_name)
    @app_name = app_name
  end

  def call(metadata)
    type = type_from(metadata)
    entity_name = name_from(metadata)
    Cadence.logger.debug("[#{app_name}]: #{type} for #{entity_name} started")

    yield

    Cadence.logger.debug("[#{app_name}]: #{type} for #{entity_name} finished")
  rescue StandardError => e
    Cadence.logger.error("[#{app_name}]: #{type} for #{entity_name} error")

    raise
  end

  private

  attr_reader :app_name

  def type_from(metadata)
    if metadata.activity?
      'Activity task'
    elsif metadata.decision?
      'Decision task'
    end
  end

  def name_from(metadata)
    if metadata.activity?
      metadata.name
    elsif metadata.decision?
      metadata.workflow_name
    end
  end
end
