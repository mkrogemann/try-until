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
      @target.send(@method, *@args)
    end
  end
end


