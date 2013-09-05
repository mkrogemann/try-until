require 'timeout'

module TryUntil
  class Probe

    def initialize(&block)
      # defaults
      @tries      = 3
      @interval   = 0
      @timeout    = :never
      @rescue     = [StandardError, Timeout::Error]
      @until      = Proc.new { true }
    end
  end
end


