module Cadence
  class Workflow
    module Status
      OPEN = :OPEN
      CLOSED = :CLOSED # agreggation of all closed statuses
      COMPLETED = :COMPLETED
      FAILED = :FAILED
      CANCELED = :CANCELED
      TERMINATED = :TERMINATED
      CONTINUED_AS_NEW = :CONTINUED_AS_NEW
      TIMED_OUT = :TIMED_OUT

      API_STATUSES = [
        COMPLETED,
        FAILED,
        CANCELED,
        TERMINATED,
        CONTINUED_AS_NEW,
        TIMED_OUT
      ].freeze
    end
  end
end
