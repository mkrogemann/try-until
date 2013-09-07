require 'spec_helper'

module TryUntil
  describe Repeater do
    describe '#initialize' do
      it 'sets default values if empty block is given' do
        repeater = Repeater.new {}
        repeater.instance_variable_get(:@tries).should == 3
      end

      it 'sets default values if no block is given' do
        repeater = Repeater.new
        repeater.instance_variable_get(:@interval).should == 0
      end

      it 'takes a block that contains its configuration' do
        repeater = Repeater.new do
          probe      Probe.new(Object.new, :to_s)
          tries      5
          interval   1.5
          rescues    [ ArgumentError, Timeout::Error ]
          condition  lambda { false }
        end
        repeater.instance_variable_get(:@rescues).should == [ ArgumentError, Timeout::Error ]
        repeater.instance_variable_get(:@condition).call.should be_false
      end
    end

    describe '#configuration' do
      it 'returns a Hash that contains the configured attributes' do
        Repeater.new.configuration[:tries].should == 3
      end
    end
  end
end