require 'cadence/execution_options'
require 'cadence/configuration'

describe Cadence::ExecutionOptions do
  subject { described_class.new(object, options, defaults) }
  let(:defaults) { nil }
  let(:options) { { domain: 'test-domain', task_list: 'test-task-list' } }

  context 'when initialized with a String' do
    let(:object) { 'TestWorkflow' }

    it 'is initialized with object as the name' do
      expect(subject.name).to eq(object)
      expect(subject.domain).to eq(options[:domain])
      expect(subject.task_list).to eq(options[:task_list])
      expect(subject.retry_policy).to be_nil
      expect(subject.timeouts).to eq({})
      expect(subject.headers).to eq({})
    end

    context 'when options include :name' do
      let(:options) do
        { name: 'OtherTestWorkflow', domain: 'test-domain', task_list: 'test-task-list' }
      end

      it 'is initialized with name from options' do
        expect(subject.name).to eq(options[:name])
        expect(subject.domain).to eq(options[:domain])
        expect(subject.task_list).to eq(options[:task_list])
        expect(subject.retry_policy).to be_nil
        expect(subject.timeouts).to eq({})
        expect(subject.headers).to eq({})
      end
    end

    context 'with defaults given' do
      let(:options) do
        {
          domain: 'test-domain',
          timeouts: { start_to_close: 10 },
          headers: { 'TestHeader' => 'Test' }
        }
      end
      let(:defaults) do
        Cadence::Configuration::Execution.new(
          domain: 'default-domain',
          task_list: 'default-task-list',
          timeouts: { schedule_to_close: 42 },
          headers: { 'DefaultHeader' => 'Default' }
        )
      end

      it 'is initialized with a mix of options and defaults' do
        expect(subject.name).to eq(object)
        expect(subject.domain).to eq(options[:domain])
        expect(subject.task_list).to eq(defaults.task_list)
        expect(subject.retry_policy).to be_nil
        expect(subject.timeouts).to eq(schedule_to_close: 42, start_to_close: 10)
        expect(subject.headers).to eq('DefaultHeader' => 'Default', 'TestHeader' => 'Test')
      end
    end

    context 'with full options' do
      let(:options) do
        {
          name: 'OtherTestWorkflow',
          domain: 'test-domain',
          task_list: 'test-task-list',
          retry_policy: { interval: 1, backoff: 2, max_attempts: 5 },
          timeouts: { start_to_close: 10 },
          headers: { 'TestHeader' => 'Test' }
        }
      end

      it 'is initialized with full options' do
        expect(subject.name).to eq(options[:name])
        expect(subject.domain).to eq(options[:domain])
        expect(subject.task_list).to eq(options[:task_list])
        expect(subject.retry_policy).to be_an_instance_of(Cadence::RetryPolicy)
        expect(subject.retry_policy.interval).to eq(options[:retry_policy][:interval])
        expect(subject.retry_policy.backoff).to eq(options[:retry_policy][:backoff])
        expect(subject.retry_policy.max_attempts).to eq(options[:retry_policy][:max_attempts])
        expect(subject.timeouts).to eq(options[:timeouts])
        expect(subject.headers).to eq(options[:headers])
      end
    end

    context 'when retry policy options are invalid' do
      let(:options) { { retry_policy: { max_attempts: 10 } } }

      it 'raises' do
        expect { subject }.to raise_error(
          Cadence::RetryPolicy::InvalidRetryPolicy,
          'interval and backoff must be set'
        )
      end
    end
  end

  context 'when initialized with an Executable' do
    class TestWorkflow < Cadence::Workflow
      domain 'domain'
      task_list 'task-list'
      retry_policy interval: 1, backoff: 2, max_attempts: 5
      timeouts start_to_close: 10
      headers 'HeaderA' => 'TestA', 'HeaderB' => 'TestB'
    end

    let(:object) { TestWorkflow }
    let(:options) { {} }

    it 'is initialized with executable values' do
      expect(subject.name).to eq(object.name)
      expect(subject.domain).to eq('domain')
      expect(subject.task_list).to eq('task-list')
      expect(subject.retry_policy).to be_an_instance_of(Cadence::RetryPolicy)
      expect(subject.retry_policy.interval).to eq(1)
      expect(subject.retry_policy.backoff).to eq(2)
      expect(subject.retry_policy.max_attempts).to eq(5)
      expect(subject.timeouts).to eq(start_to_close: 10)
      expect(subject.headers).to eq('HeaderA' => 'TestA', 'HeaderB' => 'TestB')
    end

    context 'when options are present' do
      let(:options) do
        {
          name: 'OtherTestWorkflow',
          task_list: 'test-task-list',
          retry_policy: { interval: 2, max_attempts: 10 },
          timeouts: { schedule_to_close: 20 },
          headers: { 'TestHeader' => 'Value', 'HeaderB' => 'ValueB' }
        }
      end

      it 'is initialized with a mix of options and executable values' do
        expect(subject.name).to eq(options[:name])
        expect(subject.domain).to eq('domain')
        expect(subject.task_list).to eq(options[:task_list])
        expect(subject.retry_policy).to be_an_instance_of(Cadence::RetryPolicy)
        expect(subject.retry_policy.interval).to eq(2)
        expect(subject.retry_policy.backoff).to eq(2)
        expect(subject.retry_policy.max_attempts).to eq(10)
        expect(subject.timeouts).to eq(schedule_to_close: 20, start_to_close: 10)
        expect(subject.headers).to eq(
          'TestHeader' => 'Value',
          'HeaderA' => 'TestA',
          'HeaderB' => 'ValueB' # overriden by options
        )
      end
    end

    context 'with defaults given' do
      let(:options) do
        {
          domain: 'test-domain',
          timeouts: { schedule_to_start: 10 },
          headers: { 'TestHeader' => 'Test' }
        }
      end
      let(:defaults) do
        Cadence::Configuration::Execution.new(
          domain: 'default-domain',
          task_list: 'default-task-list',
          timeouts: { schedule_to_close: 42 },
          headers: { 'DefaultHeader' => 'Default', 'HeaderA' => 'DefaultA' }
        )
      end

      it 'is initialized with a mix of executable values, options and defaults' do
        expect(subject.name).to eq(object.name)
        expect(subject.domain).to eq(options[:domain])
        expect(subject.task_list).to eq('task-list')
        expect(subject.retry_policy).to be_an_instance_of(Cadence::RetryPolicy)
        expect(subject.retry_policy.interval).to eq(1)
        expect(subject.retry_policy.backoff).to eq(2)
        expect(subject.retry_policy.max_attempts).to eq(5)
        expect(subject.timeouts).to eq(schedule_to_close: 42, start_to_close: 10, schedule_to_start: 10)
        expect(subject.headers).to eq(
          'TestHeader' => 'Test',
          'HeaderA' => 'TestA',
          'HeaderB' => 'TestB', # not overriden by defaults
          'DefaultHeader' => 'Default'
        )
      end
    end

    context 'when retry policy options are invalid' do
      let(:options) { { retry_policy: { interval: 1.5 } } }

      it 'raises' do
        expect { subject }.to raise_error(
          Cadence::RetryPolicy::InvalidRetryPolicy,
          'All intervals must be specified in whole seconds'
        )
      end
    end
  end
end
