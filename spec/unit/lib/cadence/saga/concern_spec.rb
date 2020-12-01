require 'cadence/saga/concern'

describe Cadence::Saga::Concern do
  class TestSagaConcernActivity1 < Cadence::Activity; end
  class TestSagaConcernActivity2 < Cadence::Activity; end
  class TestSagaConcernActivity3 < Cadence::Activity; end

  class TestSagaConcernWorkflow < Cadence::Workflow
    include Cadence::Saga::Concern

    def execute
      result = run_saga do |saga|
        TestSagaConcernActivity1.execute!
        saga.add_compensation(TestSagaConcernActivity2, 42)
        TestSagaConcernActivity3.execute!
      end

      return result
    end
  end

  class TestSagaConcernNonCompensableWorkflow < TestSagaConcernWorkflow
    def compensable?(error)
      false
    end
  end

  class TestSagaConcernError < StandardError
    def backtrace
      ['line 1', 'line 2']
    end
  end

  def expect_saga_to_be_compensated
    expect(TestSagaConcernActivity1).to have_received(:execute!).ordered
    expect(TestSagaConcernActivity3).to have_received(:execute!).ordered
    expect(context)
      .to have_received(:execute_activity!)
      .with(TestSagaConcernActivity2, 42).ordered
  end

  def expect_saga_not_to_be_compensated
    expect(TestSagaConcernActivity1).to have_received(:execute!).ordered
    expect(TestSagaConcernActivity3).to have_received(:execute!).ordered
    expect(context)
      .not_to have_received(:execute_activity!)
      .with(TestSagaConcernActivity2, 42).ordered
  end

  subject { TestSagaConcernWorkflow.new(context) }
  let(:context) { instance_double('Cadence::Workflow::Context') }

  before do
    allow(context).to receive(:execute_activity!)
    allow(TestSagaConcernActivity1).to receive(:execute!)
    allow(TestSagaConcernActivity3).to receive(:execute!)
  end

  context 'when execution completes' do
    it 'runs the provided block' do
      subject.execute

      expect(TestSagaConcernActivity1).to have_received(:execute!).ordered
      expect(TestSagaConcernActivity3).to have_received(:execute!).ordered
      expect(context).not_to have_received(:execute_activity!).with(TestSagaConcernActivity2, 42)
    end

    it 'returns completed result' do
      result = subject.execute

      expect(result).to be_instance_of(Cadence::Saga::Result)
      expect(result).to be_completed
    end
  end

  context 'when execution does not complete' do
    let(:logger) { instance_double('Logger') }
    let(:error) { TestSagaConcernError.new('execution failed') }

    before do
      allow(TestSagaConcernActivity3).to receive(:execute!).and_raise(error)
      allow(context).to receive(:logger).and_return(logger)
      allow(logger).to receive(:error)
      allow(logger).to receive(:debug)
    end

    it 'logs' do
      subject.execute

      expect(logger)
        .to have_received(:error)
        .with('Saga execution aborted: #<TestSagaConcernError: execution failed>')
      expect(logger).to have_received(:debug).with("line 1\nline 2")
    end

    describe 'compensate? true' do
      subject { TestSagaConcernWorkflow.new(context) }

      it 'performs compensation' do
        subject.execute

        expect_saga_to_be_compensated
      end

      it 'returns compensated result' do
        result = subject.execute

        expect(result).to be_instance_of(Cadence::Saga::Result)
        expect(result).to be_compensated
        expect(result.rollback_reason).to eq(error)
      end
    end

    describe 'compensate? false' do
      subject { TestSagaConcernNonCompensableWorkflow.new(context) }

      it 'does not perform compensation' do
        subject.execute

        expect_saga_not_to_be_compensated
      end

      it 'returns failed result' do
        result = subject.execute

        expect(result).to be_instance_of(Cadence::Saga::Result)
        expect(result).to be_failed
        expect(result.rollback_reason).to eq(error)
      end
    end

    context 'compensable?' do
      it 'compensable? is true if not defined on class' do
        expect(subject.compensable?(TestSagaConcernError)).to be_truthy
      end

      class TestClassCompensableWorkflow < TestSagaConcernWorkflow
        def self.compensable?(error)
          true
        end
      end

      it 'compensable? calls class compensable? if defined' do
        allow(TestClassCompensableWorkflow).to receive(:compensable?)
        result = TestClassCompensableWorkflow.new(context).execute
        expect(TestClassCompensableWorkflow).to have_received(:compensable?)
      end
    end
  end
end
