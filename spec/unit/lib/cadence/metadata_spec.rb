require 'cadence/metadata'

describe Cadence::Metadata do
  describe '.generate' do
    subject { described_class.generate(type, data, domain) }

    context 'with activity type' do
      let(:type) { described_class::ACTIVITY_TYPE }
      let(:data) { Fabricate(:activity_task_thrift) }
      let(:domain) { 'test-domain' }

      it 'generates metadata' do
        expect(subject.domain).to eq(domain)
        expect(subject.id).to eq(data.activityId)
        expect(subject.name).to eq(data.activityType.name)
        expect(subject.task_token).to eq(data.taskToken)
        expect(subject.attempt).to eq(data.attempt)
        expect(subject.workflow_run_id).to eq(data.workflowExecution.runId)
        expect(subject.workflow_id).to eq(data.workflowExecution.workflowId)
        expect(subject.workflow_name).to eq(data.workflowType.name)
        expect(subject.headers).to eq({})
      end

      context 'with headers' do
        let(:data) { Fabricate(:activity_task_thrift, headers: { 'Foo' => 'Bar' }) }

        it 'assigns headers' do
          expect(subject.headers).to eq('Foo' => 'Bar')
        end
      end
    end

    context 'with decision type' do
      let(:type) { described_class::DECISION_TYPE }
      let(:data) { Fabricate(:decision_task_thrift) }
      let(:domain) { 'test-domain' }

      it 'generates metadata' do
        expect(subject.domain).to eq(domain)
        expect(subject.id).to eq(data.startedEventId)
        expect(subject.task_token).to eq(data.taskToken)
        expect(subject.attempt).to eq(data.attempt)
        expect(subject.workflow_run_id).to eq(data.workflowExecution.runId)
        expect(subject.workflow_id).to eq(data.workflowExecution.workflowId)
        expect(subject.workflow_name).to eq(data.workflowType.name)
      end
    end

    context 'with unknown type' do
      let(:type) { :unknown }
      let(:data) { nil }
      let(:domain) { nil }

      it 'raises' do
        expect { subject }.to raise_error(Cadence::InternalError, 'Unsupported metadata type')
      end
    end
  end
end
