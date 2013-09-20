require 'spec_helper'

module TryUntil
  describe NullPrinter do
    describe '#printf' do
      it 'responds to #printf' do
        NullPrinter.new.respond_to?(:printf).should be_true
      end

      it 'does not produce any output' do
        io = StringIO.new
        NullPrinter.new.printf(io, 'Hello! What am I?')
        io.string.should be_empty
      end
    end
  end
end
