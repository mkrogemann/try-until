module TryUntil
  # External interface
  # Example:
  # include TryUntil
  # Repeatedly.attempt do
  #   probe       Probe.new(Object.new, :to_s)
  #   tries       5
  #   interval    10
  #   condition   lambda { |response| JSON.parse(response.body)['id'] == 'some_id' }
  # end
  class Repeatedly
    def self.attempt(&block)
      repeater = Repeater.new(&block)
      repeater.start
    end
  end
end
