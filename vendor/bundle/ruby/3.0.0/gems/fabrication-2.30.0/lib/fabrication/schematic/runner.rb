module Fabrication
  module Schematic
    class Runner
      attr_accessor :klass

      def initialize(klass)
        self.klass = klass
      end

      def sequence(name = Fabrication::Sequencer::DEFAULT, start = nil, &block)
        name = "#{klass.to_s.downcase.gsub(/::/, '_')}_#{name}"
        Fabrication::Sequencer.sequence(name, start, &block)
      end
    end
  end
end
