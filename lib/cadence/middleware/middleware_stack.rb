require 'cadence/concerns/processor'

module Cadence
  class MiddlewareStack
    # MiddlewareStack represents a stack of middleware that can be called to retrieve and activity or workflow
    # result. Internally it is represented as a doubly linked list of middleware objects. This way each link in the
    # chain can recursively call the next.process(task) method, recursively processing each middleware until the
    # activity or workflow code is called.
    #
    #                                          execute()
    #                                             | ^
    #                                             v |
    #                                         Middleware 1
    #                                             | ^
    #                                             v |
    #                                         Middleware 2
    #                                             | ^
    #                                             v |
    #                                        Activity Code

    def initialize
      @head = nil
      @tail = nil
    end

    def execute(task)
      # Start middleware execution by calling process on the bottom of the stack
      @head.process(task)
    end

    def push(middleware)
        if @head.nil?
            @head, @tail = middleware, middleware
            return
        end
        middleware.prev = tail
        @tail.next = middleware
        @tail = middleware
    end

    def pop
        @tail = @tail.prev
    end

  end
end