require 'timeout'

module TryUntil
  class Attempt

    def self.retry(&block)

    end


  end

  class DSL
    def initialize(&block)
      # defaults
      @tries      = 3
      @interval   = 0
      @timeout    = nil
      @on         = [StandardError, Timeout::Error]
      @on_retry   = nil
    end
  end
end


