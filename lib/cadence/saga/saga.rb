module Cadence
  module Saga
    class Saga
      def initialize(context)
        @context = context
        @compensations = []
      end

      def add_compensation(activity, *args, **kwargs)
        compensations << [activity, args, kwargs]
      end

      def compensate
        compensations.reverse_each do |(activity, args, kwargs)|
          context.execute_activity!(activity, *args, **kwargs)
        end
      end

      private

      attr_reader :context, :compensations
    end
  end
end
