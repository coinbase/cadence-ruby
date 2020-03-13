module Cadence
  class Middleware
    class Chain

      def initialize(middlewares)
        @middlewares = middlewares
      end

      def invoke(task)
        chain = init_middlewares
        traverse_chain = lambda do |task|
          if chain.empty?
            yield(task)
          else
            chain.shift.call(task, &traverse_chain)
          end
        end
        traverse_chain.call(task)
      end

      private

      def init_middlewares
        @middlewares.map { |m| m.new }
      end

    end
  end
end