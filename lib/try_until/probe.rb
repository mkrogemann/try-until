module TryUntil
  # This PORO holds information about a target object against which
  # to call a specified method with specified arguments
  class Probe

    # Example: Probe.new(SomeClass.new, :some_method, [arg1, arg2, ...])
    def initialize(target, method, args = [])
      @target = target
      @method = method
      @args = args
    end

    def sample
      if args_is_one_hash?
        @target.send(@method, @args)
      else
        @target.send(@method, *@args)
      end
    end

    def to_s
      "Probe: #{@target.class}##{@method}(#{@args})"
    end

    private
    def args_is_one_hash?
      @args.class == Hash
    end
  end
end


