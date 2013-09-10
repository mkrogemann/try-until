module TryUntil
  # External interface
  # Example:
  # include TryUntil
  # result = Repeatedly.attempt do
  #   probe       Probe.new(Object.new, :to_s)
  #   tries       5
  #   interval    10
  #   rescues     [ ArgumentError, IOError ]
  #   condition   lambda { |response| JSON.parse(response.body)['id'] == 'some_id' }
  # end
  #
  # Not all of the above settings are required. These are the default values:
  # probe      = nil
  # tries      = 3
  # interval   = 0
  # rescues    = []
  # condition  = lambda { false }
  #
  # If you forget to pass in a probe, you will receive a RuntimeError.
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

    # The heart of this gem: This method will repeatedly call '#sample' on the
    # subject and evaluate if the expectated result is returned.
    # In case of errors it will rescue those and continue, provided the type
    # of error is among the ones defined in @rescues.
    def execute
      raise "No probe given. You must configure a probe!" unless @probe
      @interval = 0 unless @interval
      @stop_when = lambda { false } unless @stop_when
      @rescues = [] unless @rescues
      count = 0
      while count < @attempts
        begin
          result = @probe.sample
          return result if @stop_when.call(result)
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
