require 'spec_helper'

module TryUntil
  describe NullPrinter do
    describe '#printf' do
      it 'responds to #printf' do
        expect(NullPrinter.new.respond_to? :printf).to be_truthy
      end

      it 'does not produce any output' do
        io = StringIO.new
        NullPrinter.new.printf(io, 'Hello! What am I?')
        expect(io.string).to be_empty
      end
    end
  end
end
