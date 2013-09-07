require 'spec_helper'

module TryUntil

  class TestTarget
    def initialize; @i = 0; end
    def inc; @i += 1; end
    def err; @i +=1; return @i if @i > 1; raise ArgumentError; end
  end

  describe Repeatedly do
    describe '#attempt' do
      it 'repeatedly samples its probe until a condition is met', :type => 'integration' do
        Repeatedly.attempt do
          probe       Probe.new(TestTarget.new, :inc)
          tries       5
          condition   lambda { |return_value| return_value == 4 }
        end
      end

      it 'repeatedly samples its probe until a condition is met, waiting a given time between samples', :type => 'integration' do
        Repeatedly.attempt do
          probe       Probe.new(TestTarget.new, :inc)
          tries       5
          interval    0.2
          condition   lambda { |return_value| return_value == 4 }
        end
      end

      it 'repeatedly samples its probe but the condition never gets met', :type => 'integration' do
        expect { Repeatedly.attempt do
            probe       Probe.new(TestTarget.new, :inc)
            tries       5
            condition   lambda { |return_value| return_value == 7 }
          end
        }.to raise_error(RuntimeError, "After 5 attempts, the expected result was not returned!")
      end

      it 'rescues from configured a list of errors', :type => 'integration' do
        Repeatedly.attempt do
          probe       Probe.new(TestTarget.new, :err)
          tries       3
          rescues     [ ArgumentError ]
          condition   lambda { |return_value| return_value == 2 }
        end
      end

      it 'raises an error if no probe has been setup', :type => 'integration' do
        expect {
          Repeatedly.attempt
        }.to raise_error(RuntimeError, 'No probe given. You must configure a probe!')
      end
    end
  end
end

