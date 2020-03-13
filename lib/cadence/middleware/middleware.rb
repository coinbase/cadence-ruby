require 'cadence/concerns/processor'

module Cadence
  class Middleware
    extend Concerns::Processor

    def initialize
      @next = nil
      @prev = nil
    end

    attr_accessor :next, :prev
  end
end
