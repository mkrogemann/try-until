require 'spec_helper'

module TryUntil
  describe Probe do
    describe '#sample' do
      it 'samples what its target object responds' do
        target = Object.new
        probe = Probe.new(target, :instance_variable_set, [:@some_var, "some_value"])
        expect(target).to receive(:instance_variable_set).with(:@some_var, "some_value").once
        probe.sample
      end

      it 'propagates an error raised by the target' do
        target = Object.new
        probe = Probe.new(target, :some_non_existing_method)
        expect { probe.sample }.to raise_error(NoMethodError)
      end
    end

    describe '#to_s' do
      it 'produces a human-readable String that contains target class, method and arguments' do
        probe = Probe.new(Probe.new(Object.new, :to_s), :any_method, [1, "2"])
        expect(probe.to_s).to eq('Probe: TryUntil::Probe#any_method([1, "2"])')
      end
    end
  end
end
