require 'cadence/connection/thrift'
require 'cadence/utils'

describe Cadence::Connection::Thrift do
  subject { described_class.new('host', 7933, 'test-client') }
  let(:connection) { subject.send(:connection) }

  describe '#list_open_workflow_executions' do
    let(:domain) { 'test-domain' }
    let(:from) { Time.now - 600 }
    let(:to) { Time.now }
    let(:args) { { domain: domain, from: from, to: to } }
    let(:response) do
      CadenceThrift::ListOpenWorkflowExecutionsResponse.new(executions: [], nextPageToken: '')
    end

    before do
      allow(connection).to receive(:ListOpenWorkflowExecutions).and_return(response)
    end

    it 'makes an API request' do
      subject.list_open_workflow_executions(**args)

      expect(connection).to have_received(:ListOpenWorkflowExecutions) do |request|
        expect(request).to be_an_instance_of(CadenceThrift::ListOpenWorkflowExecutionsRequest)
        expect(request.maximumPageSize).to eq(described_class::DEFAULT_OPTIONS[:max_page_size])
        expect(request.nextPageToken).to eq(nil)
        expect(request.StartTimeFilter).to be_an_instance_of(CadenceThrift::StartTimeFilter)
        expect(Cadence::Utils.time_from_nanos(request.StartTimeFilter.earliestTime).to_i)
          .to eq(from.to_i)
        expect(Cadence::Utils.time_from_nanos(request.StartTimeFilter.latestTime).to_i)
          .to eq(to.to_i)
        expect(request.executionFilter).to eq(nil)
        expect(request.typeFilter).to eq(nil)
      end
    end

    context 'when next_page_token is supplied' do
      it 'makes an API request' do
        subject.list_open_workflow_executions(**args.merge(next_page_token: 'x'))

        expect(connection).to have_received(:ListOpenWorkflowExecutions) do |request|
          expect(request).to be_an_instance_of(CadenceThrift::ListOpenWorkflowExecutionsRequest)
          expect(request.nextPageToken).to eq('x')
        end
      end
    end

    context 'when workflow_id is supplied' do
      it 'makes an API request' do
        subject.list_open_workflow_executions(**args.merge(workflow_id: 'xxx'))

        expect(connection).to have_received(:ListOpenWorkflowExecutions) do |request|
          expect(request).to be_an_instance_of(CadenceThrift::ListOpenWorkflowExecutionsRequest)
          expect(request.executionFilter)
            .to be_an_instance_of(CadenceThrift::WorkflowExecutionFilter)
          expect(request.executionFilter.workflowId).to eq('xxx')
        end
      end
    end

    context 'when workflow is supplied' do
      it 'makes an API request' do
        subject.list_open_workflow_executions(**args.merge(workflow: 'TestWorkflow'))

        expect(connection).to have_received(:ListOpenWorkflowExecutions) do |request|
          expect(request).to be_an_instance_of(CadenceThrift::ListOpenWorkflowExecutionsRequest)
          expect(request.typeFilter).to be_an_instance_of(CadenceThrift::WorkflowTypeFilter)
          expect(request.typeFilter.name).to eq('TestWorkflow')
        end
      end
    end
  end

  describe '#list_closed_workflow_executions' do
    let(:domain) { 'test-domain' }
    let(:from) { Time.now - 600 }
    let(:to) { Time.now }
    let(:args) { { domain: domain, from: from, to: to } }
    let(:response) do
      CadenceThrift::ListClosedWorkflowExecutionsResponse.new(executions: [], nextPageToken: '')
    end

    before do
      allow(connection).to receive(:ListClosedWorkflowExecutions).and_return(response)
    end

    it 'makes an API request' do
      subject.list_closed_workflow_executions(**args)

      expect(connection).to have_received(:ListClosedWorkflowExecutions) do |request|
        expect(request).to be_an_instance_of(CadenceThrift::ListClosedWorkflowExecutionsRequest)
        expect(request.maximumPageSize).to eq(described_class::DEFAULT_OPTIONS[:max_page_size])
        expect(request.nextPageToken).to eq(nil)
        expect(request.StartTimeFilter).to be_an_instance_of(CadenceThrift::StartTimeFilter)
        expect(Cadence::Utils.time_from_nanos(request.StartTimeFilter.earliestTime).to_i)
          .to eq(from.to_i)
        expect(Cadence::Utils.time_from_nanos(request.StartTimeFilter.latestTime).to_i)
          .to eq(to.to_i)
        expect(request.executionFilter).to eq(nil)
        expect(request.typeFilter).to eq(nil)
        expect(request.statusFilter).to eq(nil)
      end
    end

    context 'when next_page_token is supplied' do
      it 'makes an API request' do
        subject.list_closed_workflow_executions(**args.merge(next_page_token: 'x'))

        expect(connection).to have_received(:ListClosedWorkflowExecutions) do |request|
          expect(request).to be_an_instance_of(CadenceThrift::ListClosedWorkflowExecutionsRequest)
          expect(request.nextPageToken).to eq('x')
        end
      end
    end

    context 'when status is supplied' do
      it 'makes an API request' do
        subject.list_closed_workflow_executions(
          **args.merge(status: Cadence::Workflow::Status::COMPLETED)
        )

        expect(connection).to have_received(:ListClosedWorkflowExecutions) do |request|
          expect(request).to be_an_instance_of(CadenceThrift::ListClosedWorkflowExecutionsRequest)
          expect(request.statusFilter).to eq(CadenceThrift::WorkflowExecutionCloseStatus::COMPLETED)
        end
      end
    end

    context 'when workflow_id is supplied' do
      it 'makes an API request' do
        subject.list_closed_workflow_executions(**args.merge(workflow_id: 'xxx'))

        expect(connection).to have_received(:ListClosedWorkflowExecutions) do |request|
          expect(request).to be_an_instance_of(CadenceThrift::ListClosedWorkflowExecutionsRequest)
          expect(request.executionFilter)
            .to be_an_instance_of(CadenceThrift::WorkflowExecutionFilter)
          expect(request.executionFilter.workflowId).to eq('xxx')
        end
      end
    end

    context 'when workflow is supplied' do
      it 'makes an API request' do
        subject.list_closed_workflow_executions(**args.merge(workflow: 'TestWorkflow'))

        expect(connection).to have_received(:ListClosedWorkflowExecutions) do |request|
          expect(request).to be_an_instance_of(CadenceThrift::ListClosedWorkflowExecutionsRequest)
          expect(request.typeFilter).to be_an_instance_of(CadenceThrift::WorkflowTypeFilter)
          expect(request.typeFilter.name).to eq('TestWorkflow')
        end
      end
    end
  end
end
