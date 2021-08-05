module Cadence
  module Testing
    class FutureRegistry
      def initialize
        @store = {}
      end

      def register(id, future)
        raise 'already registered' if store.key?(id.to_s)

        store[id.to_s] = future
      end

      def complete(id, result)
        future = store[id.to_s]
        future.set(result)
        future.callbacks.each { |callback| callback.call(result) }
      end

      def fail(id, error)
        store[id.to_s].fail(error.class.name, error.message)
      end

      private

      attr_reader :store
    end
  end
end
