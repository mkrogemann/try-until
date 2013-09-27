require 'spec_helper'

module TryUntil

  class TestTarget
    def initialize; @i = 0; end
    def inc; @i += 1; end
    def err; @i += 1; return @i if @i > 1; raise ArgumentError; end
    def receives_hash(options = {})
      image_ids = options[:image_ids]
      raise 'expected enumerable' unless image_ids.respond_to?(:each)
      options[:image_ids]
    end
  end

  describe Repeatedly do
    describe '#execute' do
      it 'repeatedly samples its probe until a condition is met', :type => 'integration' do
        probe = Probe.new(TestTarget.new, :inc)
        expected_result = lambda { |return_value| return_value == 4 }
        Repeatedly.new(probe).attempts(5).interval(0.01).stop_when(expected_result).execute
      end

      it 'repeatedly samples its probe until a condition is met, waiting a given time between samples', :type => 'integration' do
        probe = Probe.new(TestTarget.new, :inc)
        expected_result = lambda { |return_value| return_value == 4 }
        time_then = Time.now
        Repeatedly.new(probe).attempts(5).interval(0.01).stop_when(expected_result).execute
        expect(Time.now - time_then).to be > 0.03
      end

      it 'returns the expected result if the probe returns it within given number of attempts', :type => 'integration' do
        probe = Probe.new(TestTarget.new, :inc)
        expected_result = lambda { |return_value| return_value == 4 }
        probe_returns = Repeatedly.new(probe).attempts(5).interval(0.01).stop_when(expected_result).execute
        probe_returns.should == 4
      end

      it 'repeatedly samples its probe but the condition never gets met', :type => 'integration' do
        probe = Probe.new(TestTarget.new, :inc)
        expected_result = lambda { |return_value| return_value == 7 }
        expect {
            Repeatedly.new(probe).attempts(5).interval(0.01).stop_when(expected_result).execute
        }.to raise_error(RuntimeError, "After 5 attempts, the expected result was not returned!")
      end

      it 'rescues from a configured list of errors', :type => 'integration' do
        probe = Probe.new(TestTarget.new, :err)
        expected_result = lambda { |return_value| return_value == 2 }
        Repeatedly.new(probe).attempts(3).interval(0.01).rescues([ ArgumentError ]).stop_when(expected_result).execute
      end

      it 're-raises an error that it rescues from when number of attempts is exceeded' do
        probe = Probe.new(TestTarget.new, :err)
        expect {
          Repeatedly.new(probe).attempts(1).interval(0.01).rescues([ ArgumentError ]).execute
        }.to raise_error(ArgumentError)
      end

      it 'prints diagnostic output to a given IO object (happy case)' do
        probe = Probe.new(TestTarget.new, :inc)
        expected_result = lambda { |return_value| return_value == 4 }
        io = StringIO.new
        Repeatedly.new(probe).attempts(5).interval(0.01).stop_when(expected_result).log_to(io).execute
        log_lines = io.string.split(/\n/)
        log_lines.size.should == 4
        log_lines[2].should match /^\d{4}-\d{2}-\d{2} \d{2}\:\d{2}\:\d{2}.*\|attempt #3\|outcome\: CONDITION_NOT_MET\|2 attempts left$/
        log_lines[3].should match /^\d{4}-\d{2}-\d{2} \d{2}\:\d{2}\:\d{2}.*\|attempt #4\|outcome\: CONDITION_MET\|1 attempts left$/
      end

      it 'prints rescued exceptions to a given IO object' do
        probe = Probe.new(TestTarget.new, :err)
        io = StringIO.new
        expect {
          Repeatedly.new(probe).attempts(5).interval(0.01).rescues([ ArgumentError ]).log_to(io).execute
        }.to raise_error
        log_lines = io.string.split(/\n/)
        log_lines.size.should == 5
        log_lines[0].should match /^\d{4}-\d{2}-\d{2} \d{2}\:\d{2}\:\d{2}.*\|attempt #1\|outcome\: ArgumentError\|4 attempts left$/
        log_lines[4].should match /^\d{4}-\d{2}-\d{2} \d{2}\:\d{2}\:\d{2}.*\|attempt #5\|outcome\: CONDITION_NOT_MET\|0 attempts left$/
      end

      it 'does not start sampling before given delay has elapsed' do
        probe = Probe.new(TestTarget.new, :inc)
        Kernel.should_receive(:sleep).with(0.02).once
        Kernel.should_receive(:sleep).with(0.01).once
        expect {
          Repeatedly.new(probe).attempts(2).interval(0.01).delay(0.02).execute
        }.to raise_error(RuntimeError, 'After 2 attempts, the expected result was not returned!')
      end

      it 'preserves a single Hash argument rather than convert it to an array' do
        target_ami_id = 'ami-some_ami'
        probe = Probe.new(TestTarget.new, :receives_hash, { :image_ids => [ target_ami_id ] })
        expected_result = lambda { |response| response == [ target_ami_id ] }
        Repeatedly.new(probe)
          .attempts(2)
          .interval(0.01)
          .stop_when(expected_result)
          .execute
      end

      it 'returns immediately without sleeping once the expected outcome is returned by probe' do
        probe = Probe.new(TestTarget.new, :inc)
        expected_result = lambda { |return_value| return_value == 1 }
        time_then = Time.now
        Repeatedly.new(probe).attempts(5).interval(1).stop_when(expected_result).execute
        expect(Time.now - time_then).to be < 0.9
      end

      it 'sleeps after taking a sample unless the number of samples taken equals the specified number of attempts' do
        probe = Probe.new(TestTarget.new, :inc)
        expected_result = lambda { |return_value| false }
        time_then = Time.new
        expect {
          Repeatedly.new(probe).attempts(3).interval(0.01).stop_when(expected_result).execute
        }.to raise_error
        expect(Time.new - time_then).to be < 0.03
      end
    end

    describe '#configuration' do
      it 'returns a Hash that contains the configured attributes' do
        probe = Probe.new(TestTarget.new, :inc)
        Repeatedly.new(probe).attempts(3).configuration[:attempts].should == 3
      end
    end
  end
end

