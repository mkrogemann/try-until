module TryUntil
  class Repeatedly
    def self.attempt(&block)
      repeater = Repeater.new(&block)
      repeater.start
    end
  end
end
