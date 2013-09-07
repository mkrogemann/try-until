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
    def self.attempt(&block)
      repeater = Repeater.new(&block)
      repeater.start
    end
  end
end
