module Fabrication
  class InfiniteRecursionError < StandardError
    def initialize(name)
      super("You appear to have infinite recursion with the `#{name}` fabricator")
    end
  end
end
