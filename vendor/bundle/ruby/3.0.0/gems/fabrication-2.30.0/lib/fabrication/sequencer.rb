require 'singleton'

module Fabrication
  class Sequencer
    include Singleton

    DEFAULT = :_default

    def self.sequence(name = DEFAULT, start = nil, &block)
      instance.sequence(name, start, &block)
    end

    def self.clear
      instance.sequences.clear
      instance.sequence_blocks.clear
    end

    def sequence(name = DEFAULT, start = nil, &block)
      idx = sequences[name] ||= start || Fabrication::Config.sequence_start
      if block
        sequence_blocks[name] = block.to_proc
      else
        sequence_blocks[name] ||= ->(i) { i }
      end.call(idx).tap do
        sequences[name] += 1
      end
    end

    def sequences
      @sequences ||= {}
    end

    def sequence_blocks
      @sequence_blocks ||= {}
    end

    def reset
      Fabrication::Config.sequence_start = nil
      @sequences = nil
      @sequence_blocks = nil
    end
  end
end
