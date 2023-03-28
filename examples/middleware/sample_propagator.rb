class SamplePropagator
  def inject!(headers)
    headers['test-header'] = 'test'
  end

  def call(metadata)
    Cadence.logger.info("Got headers! #{metadata.headers.to_h}")
    yield
  end
end