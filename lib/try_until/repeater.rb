module TryUntil
  # Repeater is a DSL and at the same time contains the main 'try-until' logic
  class Repeater

    def initialize(&block)
      # defaults
      @probe      = nil
      @tries      = 3
      @interval   = 0
      @rescues    = []
      @condition  = lambda { false }
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

    def rescues(rescues)
      @rescues = rescues
    end

    def condition(condition)
      @condition = condition
    end

    def configuration
      { :probe => @probe.to_s, :tries => @tries, :interval => @interval,
        :rescues => @rescues, :condition => @condition }
    end

    # The heart of this gem: This method will repeatedly call '#sample' on the
    # subject and evaluate if the expectated result is returned.
    # In case of errors it will rescue those and continue, provided the type
    # of error is among the ones defined in @rescues.
    def start
      raise "No probe given. You must configure a probe!" unless @probe
      count = 0
      while count < @tries
        begin
          result = @probe.sample
          return result if @condition.call(result)
        rescue *@rescues => exception
          # no special handling exception handling (yet)
        ensure
          count += 1
          Kernel.sleep @interval if @interval > 0
        end
      end
      raise "After #{@tries} attempts, the expected result was not returned!"
    end
  end
end
