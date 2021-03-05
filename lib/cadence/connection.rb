require 'cadence/connection/thrift'

module Cadence
  module Connection
    CLIENT_TYPES_MAP = {
      thrift: Cadence::Connection::Thrift
    }.freeze

    def self.generate(options = {})
      connection_class = CLIENT_TYPES_MAP[Cadence.configuration.connection_type]
      host = Cadence.configuration.host
      port = Cadence.configuration.port

      hostname = `hostname`
      thread_id = Thread.current.object_id
      identity = "#{thread_id}@#{hostname}"

      connection_class.new(host, port, identity, options)
    end
  end
end
