require 'cadence/configuration'
require 'cadence/crew'
require 'cadence/worker'

describe Cadence::Crew do
  subject { described_class.new(mock_worker, crew_size) }
  let(:crew_size) { 2 }
  let(:mock_worker) { instance_double('Cadence::Worker') }

  it 'stores the crew size' do
    expect(subject.crew_size).to eq(2)
  end

  describe '#dispatch' do
    let(:pid) { 1 }

    it 'should fork and start the worker n times' do
      Status = Struct.new(:exitstatus)
      status = Status.new(0)

      allow(subject).to receive(:fork).and_return(pid).and_yield
      allow(mock_worker).to receive(:start) { nil }
      allow(Process).to receive(:waitpid2).and_return([pid, status])

      subject.dispatch

      expect(subject).to have_received(:fork).twice
      expect(mock_worker).to have_received(:start).twice
      expect(subject.send(:crew).size).to eq(0)
    end

    describe 'signal handling' do
      let(:real_worker) { Cadence::Worker.new(Cadence::Configuration.new) }
      let(:real_crew) { described_class.new(real_worker, crew_size) }
      let(:thread_sync_delay) { 2 }

      before do
        @thread = Thread.new do
          @worker_pid = Process.pid
          subject.start
        end
        sleep 0.1 # give crew time to start
      end

      around do |example|
        # Trick RSpec into not shutting itself down on TERM signal
        old_term_handler = Signal.trap('TERM', 'SYSTEM_DEFAULT')
        old_int_handler = Signal.trap('INT', 'SYSTEM_DEFAULT')

        example.run

        # Restore the original signal handling behaviour
        Signal.trap('TERM', old_term_handler)
        Signal.trap('INT', old_int_handler)
      end

      it 'traps TERM signal' do
        Process.kill('TERM', @worker_pid)
        sleep thread_sync_delay

        expect(@thread).not_to be_alive
      end

      it 'traps INT signal' do
        Process.kill('INT', @worker_pid)
        sleep thread_sync_delay

        expect(@thread).not_to be_alive
      end
    end

    describe 'after_fork' do
      let(:worker) { Cadence::Worker.new(Cadence::Configuration.new) }
      let(:crew) { described_class.new(worker, 1) }

      before do
        allow(worker).to receive(:start) { nil }
        allow(crew).to receive(:monitor) { nil }
      end

      it 'skips the after_fork block if not set' do
        crew.should_receive(:fork) do |&block|
          expect(worker).to receive(:start)
          expect(crew.send(:after_fork_block)).to be_nil
          block.call
        end

        crew.dispatch
      end

      it 'executes the after_fork block if set' do
        executed = false
        after_fork_block = proc do |worker|
          executed = true
        end

        crew.after_fork &after_fork_block

        crew.should_receive(:fork) do |&block|
          block.call
          expect(executed).to eq(true)
          expect(worker).to have_received(:start)
        end

        crew.dispatch
      end
    end
  end

  describe 'stop' do
    let(:real_worker) { Cadence::Worker.new(Cadence::Configuration.new) }
    let(:real_crew) { described_class.new(real_worker, crew_size) }
    let(:thread_sync_delay) { 0.1 }

    it 'stops the child workers' do
      @thread = Thread.new { real_crew.dispatch }
      sleep thread_sync_delay
      expect(real_crew.send(:crew).size).to eq(crew_size)

      real_crew.stop('TERM')
      sleep thread_sync_delay
      expect(subject.send(:crew).size).to eq(0)
    end
  end
end