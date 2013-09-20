module TryUntil
  # External interface
  # Example:
  # include TryUntil
  # result = Repeatedly.new(Probe.new(Object.new, :to_s))
  #   .attempts(5)
  #   .interval(10)
  #   .rescues([ ArgumentError, IOError ])
  #   .stop_when(lambda { |response| JSON.parse(response.body)['id'] == 'some_id' })
  #   .log_to($stdout)
  # .execute
  #
  # Not all of the above settings are required. These are the default values:
  # attempts   = 3
  # interval   = 0
  # rescues    = []
  # stop_when  = lambda { |response| false }
  # log_to     = TryUntil::NullPrinter.new
  #
  class Repeatedly

    def initialize(probe)
      @probe = probe
    end

    def attempts(int_num)
      @attempts = int_num
      self
    end

    def interval(seconds)
      @interval = seconds
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
      @attempts = 3 unless @attempts
      @interval = 0 unless @interval
      @rescues = [] unless @rescues
      @stop_when = lambda { |response| false } unless @stop_when
      @log_to = NullPrinter.new unless @log_to
      count = 0
      while count < @attempts
        begin
          result = @probe.sample
          if @stop_when.call(result)
            @log_to.printf("#{Time.new}|attempt ##{count + 1}|outcome: CONDITION_MET|#{@attempts - count - 1} attempts left\n")
            return result
          end
          @log_to.printf("#{Time.new}|attempt ##{count + 1}|outcome: CONDITION_NOT_MET|#{@attempts - count - 1} attempts left\n")
        rescue *@rescues => exception
          raise exception, "During final attempt (#{@attempts} configured) target returned #{exception}" if count + 1 == @attempts
        ensure
          count += 1
          Kernel.sleep @interval if @interval > 0
        end
      end
      raise "After #{@attempts} attempts, the expected result was not returned!"
    end

    def configuration
      { :probe => @probe.to_s, :attempts => @attempts, :interval => @interval,
        :rescues => @rescues, :stop_when => @stop_when }
    end
  end
end
