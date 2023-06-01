require 'securerandom'
require 'cadence/client'
require 'cadence/configuration'
require 'cadence/workflow'
require 'cadence/workflow/history'
require 'cadence/connection/thrift'

describe Cadence::Client do
  subject { described_class.new(config) }

  let(:config) { Cadence::Configuration.new }
  let(:connection) { instance_double(Cadence::Connection::Thrift) }
  let(:domain) { 'detault-test-domain' }
  let(:workflow_id) { SecureRandom.uuid }
  let(:run_id) { SecureRandom.uuid }

  before do
    allow(Cadence::Connection)
      .to receive(:generate)
      .with(config.for_connection)
      .and_return(connection)
  end

  after do
    if subject.instance_variable_get(:@connection)
      subject.remove_instance_variable(:@connection)
    end
  end

  describe '#start_workflow' do
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
        result = subject.start_workflow(TestStartWorkflow, 42)

        expect(result).to eq(cadence_response.runId)
      end

      it 'starts a workflow using the default options' do
        subject.start_workflow(TestStartWorkflow, 42)

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

      context 'with header propagator' do
        class TestPropagator
          def inject!(header)
            header['test'] = 'asdf'
          end
        end

        it 'starts a workflow with context propagated' do
          config.add_header_propagator(TestPropagator)
          subject.start_workflow(TestStartWorkflow, 42)

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
              headers: { 'test' => 'asdf' }
            )
        end
      end

      it 'starts a workflow using the options specified' do
        subject.start_workflow(
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
        subject.schedule_workflow(
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
        subject.start_workflow(
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
        subject.start_workflow(TestStartWorkflow, 42, options: { workflow_id: '123' })

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
        subject.start_workflow(
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
        subject.start_workflow(
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

  describe '#register_domain' do
    before { allow(connection).to receive(:register_domain).and_return(nil) }

    it 'registers domain with the specified name' do
      subject.register_domain('new-domain')

      expect(connection)
        .to have_received(:register_domain)
        .with(name: 'new-domain', description: nil)
    end

    it 'registers domain with the specified name and description' do
      subject.register_domain('new-domain', 'domain description')

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
          subject.register_domain('new-domain', 'domain description')
        end.not_to raise_error
      end
    end
  end

  describe '#terminate_workflow' do
    before { allow(connection).to receive(:terminate_workflow_execution).and_return(nil) }

    it 'terminates workflow execution' do
      subject.terminate_workflow('test-domain', 'xxx', 'yyy')

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
      subject.terminate_workflow(
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

  describe '#fetch_workflow_execution_info' do
    let(:response) do
      instance_double(
        CadenceThrift::DescribeWorkflowExecutionResponse,
        workflowExecutionInfo: info_thrift
      )
    end
    let(:info_thrift) { Fabricate(:workflow_execution_info_thrift) }

    before { allow(connection).to receive(:describe_workflow_execution).and_return(response) }

    it 'requests execution info from Cadence' do
      subject.fetch_workflow_execution_info('domain', '111', '222')

      expect(connection)
        .to have_received(:describe_workflow_execution)
        .with(domain: 'domain', workflow_id: '111', run_id: '222')
    end

    it 'returns Workflow::ExecutionInfo' do
      info = subject.fetch_workflow_execution_info('domain', '111', '222')

      expect(info).to be_a(Cadence::Workflow::ExecutionInfo)
    end
  end

  describe '#get_workflow_history' do
    let(:response_mock) { double }
    let(:history_mock) { double}
    let(:event_mock) { double('EventMock', eventId: 1, timestamp: Time.now.to_f, eventType: 'ActivityTaskStarted', eventAttributes: '') }

    before do
      allow(history_mock).to receive(:events).and_return([event_mock])
      allow(response_mock).to receive(:history).and_return(history_mock)
      allow(connection).to receive(:get_workflow_execution_history).and_return(response_mock)
    end

    it 'wraps connection get_workflow_execution_history' do
        subject.get_workflow_history(
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

  describe '#reset_workflow' do
    let(:cadence_response) { CadenceThrift::StartWorkflowExecutionResponse.new(runId: 'xxx') }
    let(:history) do
      Cadence::Workflow::History.new([
        Fabricate(:workflow_execution_started_event_thrift, eventId: 1),
        Fabricate(:decision_task_scheduled_event_thrift, eventId: 2),
        Fabricate(:decision_task_started_event_thrift, eventId: 3),
        Fabricate(:decision_task_completed_event_thrift, eventId: 4),
        Fabricate(:activity_task_scheduled_event_thrift, eventId: 5),
        Fabricate(:activity_task_started_event_thrift, eventId: 6),
        Fabricate(:activity_task_completed_event_thrift, eventId: 7),
        Fabricate(:decision_task_scheduled_event_thrift, eventId: 8),
        Fabricate(:decision_task_started_event_thrift, eventId: 9),
        Fabricate(:decision_task_completed_event_thrift, eventId: 10),
        Fabricate(:activity_task_scheduled_event_thrift, eventId: 11),
        Fabricate(:activity_task_started_event_thrift, eventId: 12),
        Fabricate(:activity_task_failed_event_thrift, eventId: 13),
        Fabricate(:decision_task_scheduled_event_thrift, eventId: 14),
        Fabricate(:decision_task_started_event_thrift, eventId: 15),
        Fabricate(:decision_task_completed_event_thrift, eventId: 16),
        Fabricate(:workflow_execution_completed_event_thrift, eventId: 17)
      ])
    end

    before do
      allow(connection).to receive(:reset_workflow_execution).and_return(cadence_response)
      allow(subject)
        .to receive(:get_workflow_history)
        .with(domain: domain, workflow_id: workflow_id, run_id: run_id)
        .and_return(history)
    end

    context 'when decision_task_id is provided' do
      let(:decision_task_id) { 42 }

      it 'calls connection reset_workflow_execution' do
        subject.reset_workflow(
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
        result = subject.reset_workflow(
          'default-test-domain',
          '123',
          '1234',
          decision_task_id: decision_task_id
        )

        expect(result).to eq('xxx')
      end
    end

    context 'when neither strategy nor decision_task_id is provided' do
      it 'uses default strategy' do
        subject.reset_workflow(domain, workflow_id, run_id)

        expect(connection).to have_received(:reset_workflow_execution).with(
          domain: domain,
          workflow_id: workflow_id,
          run_id: run_id,
          reason: 'manual reset',
          decision_task_event_id: 16
        )
      end
    end

    context 'when both strategy and decision_task_id are provided' do
      it 'uses default strategy' do
        expect do
          subject.reset_workflow(
            domain,
            workflow_id,
            run_id,
            strategy: :last_decision_task,
            decision_task_id: 10
          )
        end.to raise_error(ArgumentError, 'Please specify either :strategy or :decision_task_id')
      end
    end

    context 'with a specified strategy' do
      context ':last_decision_task' do
        it 'resets workflow' do
          subject.reset_workflow(domain, workflow_id, run_id, strategy: :last_decision_task)

          expect(connection).to have_received(:reset_workflow_execution).with(
            domain: domain,
            workflow_id: workflow_id,
            run_id: run_id,
            reason: 'manual reset',
            decision_task_event_id: 16
          )
        end
      end

      context ':first_decision_task' do
        it 'resets workflow' do
          subject.reset_workflow(domain, workflow_id, run_id, strategy: :first_decision_task)

          expect(connection).to have_received(:reset_workflow_execution).with(
            domain: domain,
            workflow_id: workflow_id,
            run_id: run_id,
            reason: 'manual reset',
            decision_task_event_id: 4
          )
        end
      end

      context ':last_failed_activity' do
        it 'resets workflow' do
          subject.reset_workflow(domain, workflow_id, run_id, strategy: :last_failed_activity)

          expect(connection).to have_received(:reset_workflow_execution).with(
            domain: domain,
            workflow_id: workflow_id,
            run_id: run_id,
            reason: 'manual reset',
            decision_task_event_id: 10
          )
        end
      end

      context 'unsupported strategy' do
        it 'resets workflow' do
          expect do
            subject.reset_workflow(domain, workflow_id, run_id, strategy: :foobar)
          end.to raise_error(ArgumentError, 'Unsupported reset strategy')
        end
      end
    end
  end

  describe 'async activity operations' do
    let(:domain) { 'test-domain' }
    let(:activity_id) { rand(100).to_s }
    let(:workflow_id) { SecureRandom.uuid }
    let(:run_id) { SecureRandom.uuid }
    let(:async_token) do
      Cadence::Activity::AsyncToken.encode(domain, activity_id, workflow_id, run_id)
    end

    describe '#complete_activity' do
      before { allow(connection).to receive(:respond_activity_task_completed_by_id).and_return(nil) }

      it 'completes activity with a result' do
        subject.complete_activity(async_token, 'all work completed')

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
        subject.complete_activity(async_token)

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

    describe '#fail_activity' do
      before { allow(connection).to receive(:respond_activity_task_failed_by_id).and_return(nil) }

      it 'fails activity with a provided error' do
        subject.fail_activity(async_token, StandardError.new('something went wrong'))

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

  describe '#list_open_workflow_executions' do
    let(:from) { Time.now - 600 }
    let(:now) { Time.now }
    let(:execution_info_thrift) do
      Fabricate(:workflow_execution_info_thrift, workflow: 'TestWorkflow')
    end
    let(:response) do
      CadenceThrift::ListOpenWorkflowExecutionsResponse.new(
        executions: [execution_info_thrift],
        nextPageToken: ''
      )
    end

    before do
      allow(Time).to receive(:now).and_return(now)
      allow(connection)
        .to receive(:list_open_workflow_executions)
        .and_return(response)
    end

    it 'returns a list of executions' do
      executions = subject.list_open_workflow_executions(domain, from)

      expect(executions.length).to eq(1)
      expect(executions.first).to be_an_instance_of(Cadence::Workflow::ExecutionInfo)
    end

    context 'when history is paginated' do
      let(:response_1) do
        CadenceThrift::ListOpenWorkflowExecutionsResponse.new(
          executions: [execution_info_thrift],
          nextPageToken: 'a'
        )
      end
      let(:response_2) do
        CadenceThrift::ListOpenWorkflowExecutionsResponse.new(
          executions: [execution_info_thrift],
          nextPageToken: 'b'
        )
      end
      let(:response_3) do
        CadenceThrift::ListOpenWorkflowExecutionsResponse.new(
          executions: [execution_info_thrift],
          nextPageToken: ''
        )
      end

      before do
        allow(connection)
          .to receive(:list_open_workflow_executions)
          .and_return(response_1, response_2, response_3)
      end

      it 'calls the API 3 times' do
        subject.list_open_workflow_executions(domain, from)

        expect(connection).to have_received(:list_open_workflow_executions).exactly(3).times

        expect(connection)
          .to have_received(:list_open_workflow_executions)
          .with(domain: domain, from: from, to: now, next_page_token: nil)
          .once

        expect(connection)
          .to have_received(:list_open_workflow_executions)
          .with(domain: domain, from: from, to: now, next_page_token: 'a')
          .once

        expect(connection)
          .to have_received(:list_open_workflow_executions)
          .with(domain: domain, from: from, to: now, next_page_token: 'b')
          .once
      end

      it 'returns a list of executions' do
        executions = subject.list_open_workflow_executions(domain, from)

        expect(executions.length).to eq(3)
        executions.each do |execution|
          expect(execution).to be_an_instance_of(Cadence::Workflow::ExecutionInfo)
        end
      end
    end

    context 'when given unsupported filter' do
      let(:filter) { { foo: :bar } }

      it 'raises ArgumentError' do
        expect do
          subject.list_open_workflow_executions(domain, from, filter: filter)
        end.to raise_error(ArgumentError, 'Allowed filters are: [:workflow, :workflow_id]')
      end
    end

    context 'when given multiple filters' do
      let(:filter) { { workflow: 'TestWorkflow', workflow_id: 'xxx' } }

      it 'raises ArgumentError' do
        expect do
          subject.list_open_workflow_executions(domain, from, filter: filter)
        end.to raise_error(ArgumentError, 'Only one filter is allowed')
      end
    end

    context 'when called without filters' do
      it 'makes a request' do
        subject.list_open_workflow_executions(domain, from)

        expect(connection)
          .to have_received(:list_open_workflow_executions)
          .with(domain: domain, from: from, to: now, next_page_token: nil)
      end
    end

    context 'when called with :to' do
      it 'makes a request' do
        subject.list_open_workflow_executions(domain, from, now - 10)

        expect(connection)
          .to have_received(:list_open_workflow_executions)
          .with(domain: domain, from: from, to: now - 10, next_page_token: nil)
      end
    end

    context 'when called with a :workflow filter' do
      it 'makes a request' do
        subject.list_open_workflow_executions(domain, from, filter: { workflow: 'TestWorkflow' })

        expect(connection)
          .to have_received(:list_open_workflow_executions)
          .with(domain: domain, from: from, to: now, next_page_token: nil, workflow: 'TestWorkflow')
      end
    end

    context 'when called with a :workflow_id filter' do
      it 'makes a request' do
        subject.list_open_workflow_executions(domain, from, filter: { workflow_id: 'xxx' })

        expect(connection)
          .to have_received(:list_open_workflow_executions)
          .with(domain: domain, from: from, to: now, next_page_token: nil, workflow_id: 'xxx')
      end
    end
  end

  describe '#list_closed_workflow_executions' do
    let(:from) { Time.now - 600 }
    let(:now) { Time.now }
    let(:execution_info_thrift) do
      Fabricate(:workflow_execution_info_thrift, workflow: 'TestWorkflow')
    end
    let(:response) do
      CadenceThrift::ListClosedWorkflowExecutionsResponse.new(
        executions: [execution_info_thrift],
        nextPageToken: ''
      )
    end

    before do
      allow(Time).to receive(:now).and_return(now)
      allow(connection)
        .to receive(:list_closed_workflow_executions)
        .and_return(response)
    end

    it 'returns a list of executions' do
      executions = subject.list_closed_workflow_executions(domain, from)

      expect(executions.length).to eq(1)
      expect(executions.first).to be_an_instance_of(Cadence::Workflow::ExecutionInfo)
    end

    context 'when history is paginated' do
      let(:response_1) do
        CadenceThrift::ListClosedWorkflowExecutionsResponse.new(
          executions: [execution_info_thrift],
          nextPageToken: 'a'
        )
      end
      let(:response_2) do
        CadenceThrift::ListClosedWorkflowExecutionsResponse.new(
          executions: [execution_info_thrift],
          nextPageToken: 'b'
        )
      end
      let(:response_3) do
        CadenceThrift::ListClosedWorkflowExecutionsResponse.new(
          executions: [execution_info_thrift],
          nextPageToken: ''
        )
      end

      before do
        allow(connection)
          .to receive(:list_closed_workflow_executions)
          .and_return(response_1, response_2, response_3)
      end

      it 'calls the API 3 times' do
        subject.list_closed_workflow_executions(domain, from)

        expect(connection).to have_received(:list_closed_workflow_executions).exactly(3).times

        expect(connection)
          .to have_received(:list_closed_workflow_executions)
          .with(domain: domain, from: from, to: now, next_page_token: nil)
          .once

        expect(connection)
          .to have_received(:list_closed_workflow_executions)
          .with(domain: domain, from: from, to: now, next_page_token: 'a')
          .once

        expect(connection)
          .to have_received(:list_closed_workflow_executions)
          .with(domain: domain, from: from, to: now, next_page_token: 'b')
          .once
      end

      it 'returns a list of executions' do
        executions = subject.list_closed_workflow_executions(domain, from)

        expect(executions.length).to eq(3)
        executions.each do |execution|
          expect(execution).to be_an_instance_of(Cadence::Workflow::ExecutionInfo)
        end
      end
    end

    context 'when given unsupported filter' do
      let(:filter) { { foo: :bar } }

      it 'raises ArgumentError' do
        expect do
          subject.list_closed_workflow_executions(domain, from, filter: filter)
        end.to raise_error(ArgumentError, 'Allowed filters are: [:status, :workflow, :workflow_id]')
      end
    end

    context 'when given multiple filters' do
      let(:filter) { { workflow: 'TestWorkflow', workflow_id: 'xxx' } }

      it 'raises ArgumentError' do
        expect do
          subject.list_closed_workflow_executions(domain, from, filter: filter)
        end.to raise_error(ArgumentError, 'Only one filter is allowed')
      end
    end

    context 'when called without filters' do
      it 'makes a request' do
        subject.list_closed_workflow_executions(domain, from)

        expect(connection)
          .to have_received(:list_closed_workflow_executions)
          .with(domain: domain, from: from, to: now, next_page_token: nil)
      end
    end

    context 'when called with :to' do
      it 'makes a request' do
        subject.list_closed_workflow_executions(domain, from, now - 10)

        expect(connection)
          .to have_received(:list_closed_workflow_executions)
          .with(domain: domain, from: from, to: now - 10, next_page_token: nil)
      end
    end

    context 'when called with a :status filter' do
      it 'makes a request' do
        subject.list_closed_workflow_executions(
          domain,
          from,
          filter: { status: Cadence::Workflow::Status::COMPLETED }
        )

        expect(connection)
          .to have_received(:list_closed_workflow_executions)
          .with(
            domain: domain,
            from: from,
            to: now,
            next_page_token: nil,
            status: Cadence::Workflow::Status::COMPLETED
          )
      end
    end

    context 'when called with a :workflow filter' do
      it 'makes a request' do
        subject.list_closed_workflow_executions(domain, from, filter: { workflow: 'TestWorkflow' })

        expect(connection)
          .to have_received(:list_closed_workflow_executions)
          .with(domain: domain, from: from, to: now, next_page_token: nil, workflow: 'TestWorkflow')
      end
    end

    context 'when called with a :workflow_id filter' do
      it 'makes a request' do
        subject.list_closed_workflow_executions(domain, from, filter: { workflow_id: 'xxx' })

        expect(connection)
          .to have_received(:list_closed_workflow_executions)
          .with(domain: domain, from: from, to: now, next_page_token: nil, workflow_id: 'xxx')
      end
    end
  end

  describe '#signal_workflow_execution' do
    before do
      allow(connection).to receive(:signal_workflow_execution).and_return(nil)

      it 'calls connection signal_workflow_execution' do
        subject.signal_workflow_execution(
          domain: 'default-test-domain',
          signal: 'signal-name',
          workflow_id: 'workflow-id',
          run_id: 'run-id',
          input: 'input'
        )

        expect(connection).to have_received(:signal_workflow_execution).with(
          domain: 'default-test-domain',
          workflow_id: 'workflow-id',
          run_id: 'run-id',
          signal: 'signal-name',
          input: 'input'
        )
      end
    end
  end
end
