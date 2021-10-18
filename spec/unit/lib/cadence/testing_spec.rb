require 'cadence/testing'
require 'cadence/client'
require 'cadence/configuration'
require 'cadence/workflow'
require 'cadence/workflow/status'

describe Cadence::Testing::CadenceOverride do
  let(:client) { Cadence::Client.new(config) }
  let(:config) { Cadence::Configuration.new }

  class TestCadenceOverrideWorkflow < Cadence::Workflow
    domain 'default-domain'
    task_list 'default-task-list'

    def execute; end
  end

  context 'when testing mode is disabled' do
    describe 'Cadence.start_workflow' do
      let(:connection) { instance_double('Cadence::Connection::Thrift') }
      let(:response) { CadenceThrift::StartWorkflowExecutionResponse.new(runId: 'xxx') }

      before { allow(Cadence::Connection).to receive(:generate).and_return(connection) }
      after { client.remove_instance_variable(:@connection) }

      it 'invokes original implementation' do
        allow(connection).to receive(:start_workflow_execution).and_return(response)

        client.start_workflow(TestCadenceOverrideWorkflow)

        expect(connection)
          .to have_received(:start_workflow_execution)
          .with(hash_including(workflow_name: 'TestCadenceOverrideWorkflow'))
      end
    end
  end

  context 'when testing mode is local' do
    around do |example|
      Cadence::Testing.local! { example.run }
    end

    describe 'Cadence.start_workflow' do
      let(:workflow) { TestCadenceOverrideWorkflow.new(nil) }

      before { allow(TestCadenceOverrideWorkflow).to receive(:new).and_return(workflow) }

      it 'calls the workflow directly' do
        allow(workflow).to receive(:execute)

        client.start_workflow(TestCadenceOverrideWorkflow)

        expect(workflow).to have_received(:execute)
        expect(TestCadenceOverrideWorkflow)
          .to have_received(:new)
          .with(an_instance_of(Cadence::Testing::LocalWorkflowContext))
      end

      describe 'execution control' do
        subject do
          client.start_workflow(
            TestCadenceOverrideWorkflow,
            options: { workflow_id: workflow_id, workflow_id_reuse_policy: policy }
          )
        end

        let(:execution) { instance_double(Cadence::Testing::WorkflowExecution, status: status) }
        let(:workflow_id) { SecureRandom.uuid }
        let(:run_id) { SecureRandom.uuid }
        let(:error_class) { CadenceThrift::WorkflowExecutionAlreadyStartedError }

        # Simulate existing execution
        before do
          if execution
            client.send(:executions)[[workflow_id, run_id]] = execution
          end
        end

        context 'reuse policy is :allow_failed' do
          let(:policy) { :allow_failed }

          context 'when workflow was not yet started' do
            let(:execution) { nil }

            it { is_expected.to be_a(String) }
          end

          context 'when workflow is started' do
            let(:status) { Cadence::Workflow::Status::OPEN }

            it 'raises error' do
              expect { subject }.to raise_error(error_class)
            end
          end

          context 'when workflow has completed' do
            let(:status) { Cadence::Workflow::Status::COMPLETED }

            it 'raises error' do
              expect { subject }.to raise_error(error_class)
            end
          end

          context 'when workflow has failed' do
            let(:status) { Cadence::Workflow::Status::FAILED }

            it { is_expected.to be_a(String) }
          end
        end

        context 'reuse policy is :allow' do
          let(:policy) { :allow }

          context 'when workflow was not yet started' do
            let(:execution) { nil }

            it { is_expected.to be_a(String) }
          end

          context 'when workflow is started' do
            let(:status) { Cadence::Workflow::Status::OPEN }

            it 'raises error' do
              expect { subject }.to raise_error(error_class)
            end
          end

          context 'when workflow has completed' do
            let(:status) { Cadence::Workflow::Status::COMPLETED }

            it { is_expected.to be_a(String) }
          end

          context 'when workflow has failed' do
            let(:status) { Cadence::Workflow::Status::FAILED }

            it { is_expected.to be_a(String) }
          end
        end

        context 'reuse policy is :reject' do
          let(:policy) { :reject }

          context 'when workflow was not yet started' do
            let(:execution) { nil }

            it { is_expected.to be_a(String) }
          end

          context 'when workflow is started' do
            let(:status) { Cadence::Workflow::Status::OPEN }

            it 'raises error' do
              expect { subject }.to raise_error(error_class)
            end
          end

          context 'when workflow has completed' do
            let(:status) { Cadence::Workflow::Status::COMPLETED }

            it 'raises error' do
              expect { subject }.to raise_error(error_class)
            end
          end

          context 'when workflow has failed' do
            let(:status) { Cadence::Workflow::Status::FAILED }

            it 'raises error' do
              expect { subject }.to raise_error(error_class)
            end
          end
        end
      end
    end
  end
end
