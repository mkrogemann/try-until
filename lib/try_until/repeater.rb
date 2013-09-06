module TryUntil
  class Repeater

    def initialize(&block)
      # defaults
      @probe      = nil
      @tries      = 3
      @interval   = 0
      @timeout    = :never
      @rescues    = [ StandardError, Timeout::Error ]
      @condition  = Proc.new { true }
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

    def configuration
      { :probe => @probe.to_s, :tries => @tries, :interval => @interval,
        :timeout => @timeout, :rescues => @rescues, :condition => @condition }
    end

    def start
    end
  end
end