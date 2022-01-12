require 'logger'

module Cadence

  # Creates a group of child worker processes and tracks their state
  # Params:
  # +worker+:: The worker that will be forked and duplicated in child processes
  # +crew_size+:: The number of workers that will be created
  class Crew
    attr_reader :crew_size

    def initialize(worker, crew_size)
      @worker = worker
      @crew = []
      @crew_size = crew_size
      @logger = Logger.new(STDOUT, progname: 'cadence_client')
    end

    # Creates the worker processes and starts monitoring them
    def dispatch
      logger.info "Dispatching crew. Size: #{crew_size}"
      trap_signals
      (1..crew_size).each { dispatch_worker }
      monitor
    end

    # Stops the child worker processes
    def stop(signal)
      logger.info 'Stopping crew'
      crew.each { |pid| stop_worker(signal, pid) }
    end

    private

    attr_reader :worker, :crew, :logger

    def dispatch_worker
      pid = fork { worker.start }
      crew << pid
      logger.info "Worker started. pid: #{pid}"
      pid
    end

    def monitor
      while crew.length.positive?
        (pid, status) = ::Process.waitpid2(-1)
        crew.delete(pid)
        logger.info "Worker quit. pid: #{pid.to_s}, exitstatus: #{status.exitstatus}, remaining_workers: #{crew.length}"
      end

      logger.info 'The crew has finished up!'
    end

    def stop_worker(signal, pid)
      logger.info "Sending signal to worker. pid: #{pid}, signal: #{signal}"
      Process.kill(signal, pid)
    end

    def trap_signals
      %w[TERM INT].each do |signal|
        Signal.trap(signal) { stop(signal) }
      end
    end
  end
end
