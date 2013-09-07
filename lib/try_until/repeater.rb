module TryUntil
  # Repeater is a DSL and at the same time contains the
  class Repeater

    def initialize(&block)
      # defaults
      @probe      = nil
      @tries      = 3
      @interval   = 0
      @timeout    = :never
      @rescues    = [ StandardError, Timeout::Error ]
      @condition  = lambda { true }
      instance_eval(&block) if block
    end

    def probe(probe)
      @probe = probe
    end

    def tries(tries)
      @tries = tries
    end

    def interval(interval)
      @interval = interval
    end

    def timeout(timeout)
      @timeout = timeout
    end

    def rescues(rescues)
      @rescues = rescues
    end

    def condition(condition)
      @condition = condition
    end

    def configuration
      { :probe => @probe.to_s, :tries => @tries, :interval => @interval,
        :timeout => @timeout, :rescues => @rescues, :condition => @condition }
    end

    # The heart of this gem: This method will repeatedly call '#sample' on the
    # subject and evaluate if the expectated result is returned.
    # In case of errors it will rescue those and continue, provided the type
    # of error is among the ones defined in @rescues.
    # If a timeout is defined then it will be applied to each call of '#sample'.
    def start

    end
  end
end