require 'cadence'
require 'cadence/workflow'
require 'cadence/connection/thrift'

describe Cadence do
  describe 'client operations' do
    let(:connection) { instance_double(Cadence::Connection::Thrift) }

    before { allow(Cadence::Connection).to receive(:generate).and_return(connection) }
    after { described_class.remove_instance_variable(:@connection) }

    describe '.start_workflow' do
      let(:cadence_response) do
        CadenceThrift::StartWorkflowExecutionResponse.new(runId: 'xxx')
      end

      before { allow(connection).to receive(:start_workflow_execution).and_return(cadence_response) }

      context 'using a workflow class' do
        class TestStartWorkflow < Cadence::Workflow
          domain 'default-test-domain'
          task_list 'default-test-task-list'
        end

        it 'returns run_id' do
          result = described_class.start_workflow(TestStartWorkflow, 42)

          expect(result).to eq(cadence_response.runId)
        end

        it 'starts a workflow using the default options' do
          described_class.start_workflow(TestStartWorkflow, 42)

          expect(connection)
            .to have_received(:start_workflow_execution)
            .with(
              domain: 'default-test-domain',
              workflow_id: an_instance_of(String),
              workflow_name: 'TestStartWorkflow',
              task_list: 'default-test-task-list',
              input: [42],
              task_timeout: Cadence.configuration.timeouts[:task],
              execution_timeout: Cadence.configuration.timeouts[:execution],
              workflow_id_reuse_policy: nil,
              headers: {}
            )
        end

        it 'starts a workflow using the options specified' do
          described_class.start_workflow(
            TestStartWorkflow,
            42,
            options: {
              name: 'test-workflow',
              domain: 'test-domain',
              task_list: 'test-task-list',
              headers: { 'Foo' => 'Bar' }
            }
          )

          expect(connection)
            .to have_received(:start_workflow_execution)
            .with(
              domain: 'test-domain',
              workflow_id: an_instance_of(String),
              workflow_name: 'test-workflow',
              task_list: 'test-task-list',
              input: [42],
              task_timeout: Cadence.configuration.timeouts[:task],
              execution_timeout: Cadence.configuration.timeouts[:execution],
              workflow_id_reuse_policy: nil,
              headers: { 'Foo' => 'Bar' }
            )
        end

        it 'starts a cron workflow' do
          described_class.schedule_workflow(
            TestStartWorkflow,
            '* * * * *',
            42,
            options: {
              name: 'test-workflow',
              domain: 'test-domain',
              task_list: 'test-task-list',
              headers: { 'Foo' => 'Bar' },

            }
          )

          expect(connection)
            .to have_received(:start_workflow_execution)
            .with(
              domain: 'test-domain',
              workflow_id: an_instance_of(String),
              workflow_name: 'test-workflow',
              task_list: 'test-task-list',
              cron_schedule: '* * * * *',
              input: [42],
              task_timeout: Cadence.configuration.timeouts[:task],
              execution_timeout: Cadence.configuration.timeouts[:execution],
              workflow_id_reuse_policy: nil,
              headers: { 'Foo' => 'Bar' }
            )
        end

        it 'starts a workflow using a mix of input, keyword arguments and options' do
          described_class.start_workflow(
            TestStartWorkflow,
            42,
            arg_1: 1,
            arg_2: 2,
            options: { name: 'test-workflow' }
          )

          expect(connection)
            .to have_received(:start_workflow_execution)
            .with(
              domain: 'default-test-domain',
              workflow_id: an_instance_of(String),
              workflow_name: 'test-workflow',
              task_list: 'default-test-task-list',
              input: [42, { arg_1: 1, arg_2: 2 }],
              task_timeout: Cadence.configuration.timeouts[:task],
              execution_timeout: Cadence.configuration.timeouts[:execution],
              workflow_id_reuse_policy: nil,
              headers: {}
            )
        end

        it 'starts a workflow using specified workflow_id' do
          described_class.start_workflow(TestStartWorkflow, 42, options: { workflow_id: '123' })

          expect(connection)
            .to have_received(:start_workflow_execution)
            .with(
              domain: 'default-test-domain',
              workflow_id: '123',
              workflow_name: 'TestStartWorkflow',
              task_list: 'default-test-task-list',
              input: [42],
              task_timeout: Cadence.configuration.timeouts[:task],
              execution_timeout: Cadence.configuration.timeouts[:execution],
              workflow_id_reuse_policy: nil,
              headers: {}
            )
        end

        it 'starts a workflow with a workflow id reuse policy' do
          described_class.start_workflow(
            TestStartWorkflow, 42, options: { workflow_id_reuse_policy: :allow }
          )

          expect(connection)
            .to have_received(:start_workflow_execution)
            .with(
              domain: 'default-test-domain',
              workflow_id: an_instance_of(String),
              workflow_name: 'TestStartWorkflow',
              task_list: 'default-test-task-list',
              input: [42],
              task_timeout: Cadence.configuration.timeouts[:task],
              execution_timeout: Cadence.configuration.timeouts[:execution],
              workflow_id_reuse_policy: :allow,
              headers: {}
            )
        end
      end

      context 'using a string reference' do
        it 'starts a workflow' do
          described_class.start_workflow(
            'test-workflow',
            42,
            options: { domain: 'test-domain', task_list: 'test-task-list' }
          )

          expect(connection)
            .to have_received(:start_workflow_execution)
            .with(
              domain: 'test-domain',
              workflow_id: an_instance_of(String),
              workflow_name: 'test-workflow',
              task_list: 'test-task-list',
              input: [42],
              task_timeout: Cadence.configuration.timeouts[:task],
              execution_timeout: Cadence.configuration.timeouts[:execution],
              workflow_id_reuse_policy: nil,
              headers: {}
            )
        end
      end
    end

    describe '.register_domain' do
      before { allow(connection).to receive(:register_domain).and_return(nil) }

      it 'registers domain with the specified name' do
        described_class.register_domain('new-domain')

        expect(connection)
          .to have_received(:register_domain)
          .with(name: 'new-domain', description: nil)
      end

      it 'registers domain with the specified name and description' do
        described_class.register_domain('new-domain', 'domain description')

        expect(connection)
          .to have_received(:register_domain)
          .with(name: 'new-domain', description: 'domain description')
      end

      context 'when domain is already registered' do
        before do
          allow(connection)
            .to receive(:register_domain)
            .and_raise(CadenceThrift::DomainAlreadyExistsError)
        end

        it 'does not raise error' do
          expect do
            described_class.register_domain('new-domain', 'domain description')
          end.not_to raise_error
        end
      end
    end

    describe '.terminate_workflow' do
      before { allow(connection).to receive(:terminate_workflow_execution).and_return(nil) }

      it 'terminates workflow execution' do
        described_class.terminate_workflow('test-domain', 'xxx', 'yyy')

        expect(connection)
          .to have_received(:terminate_workflow_execution)
          .with(
            domain: 'test-domain',
            workflow_id: 'xxx',
            run_id: 'yyy',
            reason: 'manual termination',
            details: nil
          )
      end

      it 'terminates workflow execution with extra details' do
        described_class.terminate_workflow(
          'test-domain',
          'xxx',
          'yyy',
          reason: 'test reason',
          details: '{ "foo": "bar" }'
        )

        expect(connection)
          .to have_received(:terminate_workflow_execution)
          .with(
            domain: 'test-domain',
            workflow_id: 'xxx',
            run_id: 'yyy',
            reason: 'test reason',
            details: '{ "foo": "bar" }'
          )
      end
    end

    describe '.fetch_workflow_execution_info' do
      let(:response) do
        instance_double(
          CadenceThrift::DescribeWorkflowExecutionResponse,
          workflowExecutionInfo: info_thrift
        )
      end
      let(:info_thrift) { Fabricate(:workflow_execution_info_thrift) }

      before { allow(connection).to receive(:describe_workflow_execution).and_return(response) }

      it 'requests execution info from Cadence' do
        described_class.fetch_workflow_execution_info('domain', '111', '222')

        expect(connection)
          .to have_received(:describe_workflow_execution)
          .with(domain: 'domain', workflow_id: '111', run_id: '222')
      end

      it 'returns Workflow::ExecutionInfo' do
        info = described_class.fetch_workflow_execution_info('domain', '111', '222')

        expect(info).to be_a(Cadence::Workflow::ExecutionInfo)
      end
    end

    describe '.get_workflow_history' do
      let(:response_mock) { double }
      let(:history_mock) { double}
      let(:event_mock) { double('EventMock', eventId: 1, timestamp: Time.now.to_f, eventType: 'ActivityTaskStarted', eventAttributes: '') }

      before do
        allow(history_mock).to receive(:events).and_return([event_mock])
        allow(response_mock).to receive(:history).and_return(history_mock)
        allow(connection).to receive(:get_workflow_execution_history).and_return(response_mock)
      end

      it 'wraps connection get_workflow_execution_history' do
          described_class.get_workflow_history(
            domain:'default-test-domain',
            workflow_id: '123',
            run_id: '1234'
          )
          expect(connection).to have_received(:get_workflow_execution_history).with(
            domain: 'default-test-domain',
            workflow_id: '123',
            run_id: '1234'
          )
      end
    end

    describe '.reset_workflow' do
      let(:cadence_response) { CadenceThrift::StartWorkflowExecutionResponse.new(runId: 'xxx') }

      before { allow(connection).to receive(:reset_workflow_execution).and_return(cadence_response) }

      context 'when decision_task_id is provided' do
        let(:decision_task_id) { 42 }

        it 'calls connection reset_workflow_execution' do
          described_class.reset_workflow(
            'default-test-domain',
            '123',
            '1234',
            decision_task_id: decision_task_id,
            reason: 'Test reset'
          )

          expect(connection).to have_received(:reset_workflow_execution).with(
            domain: 'default-test-domain',
            workflow_id: '123',
            run_id: '1234',
            reason: 'Test reset',
            decision_task_event_id: decision_task_id
          )
        end

        it 'returns the new run_id' do
          result = described_class.reset_workflow(
            'default-test-domain',
            '123',
            '1234',
            decision_task_id: decision_task_id
          )

          expect(result).to eq('xxx')
        end
      end
    end

    context 'activity operations' do
      let(:domain) { 'test-domain' }
      let(:activity_id) { rand(100).to_s }
      let(:workflow_id) { SecureRandom.uuid }
      let(:run_id) { SecureRandom.uuid }
      let(:async_token) do
        Cadence::Activity::AsyncToken.encode(domain, activity_id, workflow_id, run_id)
      end

      describe '.complete_activity' do
        before { allow(connection).to receive(:respond_activity_task_completed_by_id).and_return(nil) }

        it 'completes activity with a result' do
          described_class.complete_activity(async_token, 'all work completed')

          expect(connection)
            .to have_received(:respond_activity_task_completed_by_id)
            .with(
              domain: domain,
              activity_id: activity_id,
              workflow_id: workflow_id,
              run_id: run_id,
              result: 'all work completed'
            )
        end

        it 'completes activity without a result' do
          described_class.complete_activity(async_token)

          expect(connection)
            .to have_received(:respond_activity_task_completed_by_id)
            .with(
              domain: domain,
              activity_id: activity_id,
              workflow_id: workflow_id,
              run_id: run_id,
              result: nil
            )
        end
      end

      describe '.fail_activity' do
        before { allow(connection).to receive(:respond_activity_task_failed_by_id).and_return(nil) }

        it 'fails activity with a provided error' do
          described_class.fail_activity(async_token, StandardError.new('something went wrong'))

          expect(connection)
            .to have_received(:respond_activity_task_failed_by_id)
            .with(
              domain: domain,
              activity_id: activity_id,
              workflow_id: workflow_id,
              run_id: run_id,
              reason: 'StandardError',
              details: 'something went wrong'
            )
        end
      end
    end
  end

  describe '.configure' do
    it 'calls a block with the configuration' do
      expect do |block|
        described_class.configure(&block)
      end.to yield_with_args(described_class.configuration)
    end
  end

  describe '.configuration' do
    it 'returns Cadence::Configuration object' do
      expect(described_class.configuration).to be_an_instance_of(Cadence::Configuration)
    end
  end

  describe '.logger' do
    it 'returns preconfigured Cadence logger' do
      expect(described_class.logger).to eq(described_class.configuration.logger)
    end
  end
end
