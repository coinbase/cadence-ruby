require 'fiber'
# This class wraps ruby's Fiber, but copies all the thread-local variables from the parent Thread
#
# In Ruby it is not uncommon to store information in Thread.current[] variables, which will not be
# accessible within a regular Fiber
#
module Cadence
  class FiberWithParentLocals < Fiber
    def self.new
      thread_locals = Thread.current.keys.map { |key| [key, Thread.current[key]] }
      super do
        thread_locals.each { |(key, value)| Thread.current[key] = value }
        yield
      end
    end
  end
end