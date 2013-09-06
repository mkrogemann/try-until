require 'spec_helper'

module TryUntil
  describe Probe do
    describe '#sample' do
      it 'samples what its target object responds' do
        target = Object.new
        probe = Probe.new(target, :instance_variable_set, [:@some_var, "some_value"])
        target.should_receive(:instance_variable_set).with(:@some_var, "some_value").once
        probe.sample
      end

      it 'propagates an error raised by the target' do
        target = Object.new
        probe = Probe.new(target, :some_non_existing_method)
        expect { probe.sample }.to raise_error(NoMethodError)
      end
    end
  end
end