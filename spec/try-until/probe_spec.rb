require 'spec_helper'

module TryUntil
  describe Probe do
    describe '#initialize' do
      it 'sets default values if empty block is given' do
        probe = Probe.new {}
        probe.instance_variable_get(:@tries).should == 3
      end

      it 'sets default values if no block is given' do
        probe = Probe.new
        probe.instance_variable_get(:@timeout).should == :never
      end

      it 'takes a block that contains its configuration' do
        probe = Probe.new do
          tries      7
          interval   10
          timeout    2.0
          rescues    [ ArgumentError, Timeout::Error ]
        end
        probe.instance_variable_get(:@rescues).should == [ ArgumentError, Timeout::Error ]
        probe.instance_variable_get(:@timeout).should == 2.0
      end
    end

    describe '#configuration' do
      it 'returns a Hash that contains the configured attributes' do
        Probe.new.configuration[:rescues].should == [ StandardError, Timeout::Error ]
      end
    end
  end
end