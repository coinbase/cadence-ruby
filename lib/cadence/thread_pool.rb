# This class implements a very simple ThreadPool with the ability to
# block until at least one thread becomes available. This allows Pollers
# to only poll when there's an available thread in the pool.
#
# NOTE: There's a minor race condition that can occur between calling
#       #wait_for_available_threads and #schedule, but should be rare
#
module Cadence
  class ThreadPool
    attr_reader :size

    def initialize(size)
      @size = size
      @queue = Queue.new
      @mutex = Mutex.new
      @availability = ConditionVariable.new
      @available_threads = size
      @pool = Array.new(size) do |i|
        Thread.new { poll }
      end
    end

    def wait_for_available_threads
      @mutex.synchronize do
        while @available_threads <= 0
          @availability.wait(@mutex)
        end
      end
    end

    def schedule(&block)
      @mutex.synchronize do
        @available_threads -= 1
        @queue << block
      end
    end

    def shutdown
      size.times do
        schedule { throw EXIT_SYMBOL }
      end

      @pool.each(&:join)
    end

    private

    EXIT_SYMBOL = :exit

    def poll
      catch(EXIT_SYMBOL) do
        loop do
          run(@queue.pop)
          @mutex.synchronize do
            @available_threads += 1
            @availability.signal
          end
        end
      end
    end

    def run(job)
      job.call if job
    rescue Exception
      # Make sure we don't loose a thread
    end
  end
end
