module TryUntil
  # External interface
  # Example:
  # include TryUntil
  # result = Repeatedly.new(Probe.new(Object.new, :to_s))
  #   .attempts(5)
  #   .interval(10)
  #   .delay(120)
  #   .rescues([ ArgumentError, IOError ])
  #   .stop_when(lambda { |response| JSON.parse(response.body)['id'] == 'some_id' })
  #   .log_to($stdout)
  #   .execute
  #
  # Not all of the above settings are required. These are the default values:
  # attempts   = 3
  # interval   = 0
  # delay      = 0
  # rescues    = []
  # stop_when  = lambda { |response| false }
  # log_to     = TryUntil::NullPrinter.new
  #
  class Repeatedly

    def initialize(probe)
      @probe = probe
      defaults
    end

    def attempts(int_num)
      @attempts = int_num
      self
    end

    def interval(seconds)
      @interval = seconds
      self
    end

    def delay(seconds)
      @delay = seconds
      self
    end

    def rescues(errors)
      @rescues = errors
      self
    end

    def stop_when(callable)
      @stop_when = callable
      self
    end

    def log_to(io)
      @log_to = io
      self
    end

    # The heart of this gem: This method will repeatedly call '#sample' on the
    # subject and evaluate if the expectated result is returned.
    # In case of errors it will rescue those and continue, provided the type
    # of error is among the ones defined in @rescues.
    def execute
      Kernel.sleep(@delay) if @delay > 0
      count = 1
      condition_met = false
      while count <= @attempts
        begin
          result = @probe.sample
          if @stop_when.call(result)
            condition_met = true
            log_outcome(count, 'CONDITION_MET')
            return result
          end
          log_outcome(count, 'CONDITION_NOT_MET')
        rescue *@rescues => exception
          log_outcome(count, exception.class)
          raise exception, "During final attempt (#{@attempts} configured) target returned #{exception}" if count == @attempts
        ensure
          unless condition_met
            Kernel.sleep @interval if count < @attempts && @interval > 0
            count += 1
          end
        end
      end
      raise "After #{@attempts} attempts, the expected result was not returned!"
    end

    def configuration
      { :probe => @probe.to_s, :attempts => @attempts, :interval => @interval,
        :delay => @delay, :rescues => @rescues, :log_to => @log_to }
    end

    private
    def log_outcome(count, outcome)
      @log_to.printf("#{Time.new}|attempt ##{count}|outcome: #{outcome}|#{@attempts - count} attempts left\n")
    end

    def defaults
      @attempts = 3 unless @attempts
      @interval = 0 unless @interval
      @delay = 0 unless @delay
      @rescues = [] unless @rescues
      @stop_when = lambda { |response| false } unless @stop_when
      @log_to = NullPrinter.new unless @log_to
    end
  end
end
