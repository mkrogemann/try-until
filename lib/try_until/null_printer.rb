module TryUntil
  # Null-Object: Will be used unless user specifies another target for
  # informational messages printed while Repeatedly does its work
  class NullPrinter
    def printf(*args); end
  end
end