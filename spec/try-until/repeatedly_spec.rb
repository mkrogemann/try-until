require 'spec_helper'

module TryUntil

  class TestTarget
    def initialize; @i = 0; end
    def inc; @i += 1; end
    def err; @i += 1; return @i if @i > 1; raise ArgumentError; end
  end

  describe Repeatedly do
    describe '#execute' do
      it 'repeatedly samples its probe until a condition is met', :type => 'integration' do
        probe = Probe.new(TestTarget.new, :inc)
        expected_result = lambda { |return_value| return_value == 4 }
        Repeatedly.new(probe).attempts(5).stop_when(expected_result).execute
      end

      it 'repeatedly samples its probe until a condition is met, waiting a given time between samples', :type => 'integration' do
        time_then = Time.now
        probe = Probe.new(TestTarget.new, :inc)
        expected_result = lambda { |return_value| return_value == 4 }
        Repeatedly.new(probe).attempts(5).interval(0.2).stop_when(expected_result).execute
        expect(Time.now - time_then).to be > 0.7
      end

      it 'returns the expected result if the probe returns it within given number of attempts', :type => 'integration' do
        probe = Probe.new(TestTarget.new, :inc)
        expected_result = lambda { |return_value| return_value == 4 }
        probe_returns = Repeatedly.new(probe).attempts(5).interval(0.2).stop_when(expected_result).execute
        probe_returns.should == 4
      end

      it 'repeatedly samples its probe but the condition never gets met', :type => 'integration' do
        probe = Probe.new(TestTarget.new, :inc)
        expected_result = lambda { |return_value| return_value == 7 }
        expect {
            Repeatedly.new(probe).attempts(5).stop_when(expected_result).execute
        }.to raise_error(RuntimeError, "After 5 attempts, the expected result was not returned!")
      end

      it 'rescues from a configured list of errors', :type => 'integration' do
        probe = Probe.new(TestTarget.new, :err)
        expected_result = lambda { |return_value| return_value == 2 }
        Repeatedly.new(probe).attempts(3).rescues([ ArgumentError ]).stop_when(expected_result).execute
      end

      it 're-raises an error that it rescues from when number of attempts is exceeded' do
        probe = Probe.new(TestTarget.new, :err)
        expect {
          Repeatedly.new(probe).attempts(2).rescues([ ArgumentError ]).execute
        }.to raise_error(ArgumentError)
      end

      describe '#configuration' do
        it 'returns a Hash that contains the configured attributes' do
          probe = Probe.new(TestTarget.new, :inc)
          Repeatedly.new(probe).attempts(3).configuration[:attempts].should == 3
        end
      end
    end
  end
end

