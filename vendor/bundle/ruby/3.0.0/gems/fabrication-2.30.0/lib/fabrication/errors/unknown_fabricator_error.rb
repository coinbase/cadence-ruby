module Fabrication
  class UnknownFabricatorError < StandardError
    def initialize(name)
      super("No Fabricator defined for '#{name}'")
    end
  end
end
