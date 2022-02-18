require 'cadence/concerns/versioned'
require 'cadence/workflow/context'

describe Cadence::Concerns::Versioned do
  class TestVersionedWorkflowV1 < Cadence::Workflow
  end

  class TestVersionedWorkflowV2 < Cadence::Workflow
    domain 'new-domain'
    task_list 'new-task-list'
    retry_policy interval: 5, backoff: 1, max_attempts: 2
    timeouts execution: 1
    headers 'HeaderV2' => 'TestV2'
  end

  class TestVersionedWorkflow < Cadence::Workflow
    include Cadence::Concerns::Versioned

    domain 'domain'
    task_list 'task-list'
    retry_policy interval: 1, backoff: 2, max_attempts: 5
    timeouts start_to_close: 10
    headers 'HeaderA' => 'TestA', 'HeaderB' => 'TestB'

    version 1, TestVersionedWorkflowV1
    version 2, TestVersionedWorkflowV2
  end

  describe described_class::Workflow do
    subject { described_class.new(TestVersionedWorkflow, version) }

    describe '#initialize' do
      before { allow(TestVersionedWorkflow).to receive(:pick_version).and_call_original }

      context 'when passed no version header' do
        let(:version) { nil }

        it 'initializes the latest version' do
          expect(subject.version).to eq(2)
          expect(subject.main_class).to eq(TestVersionedWorkflow)
          expect(subject.version_class).to eq(TestVersionedWorkflowV2)
        end

        it 'calls version picker' do
          subject

          expect(TestVersionedWorkflow).to have_received(:pick_version)
        end
      end

      context 'when passed a specific version header' do
        let(:version) { 1 }

        it 'initializes the specified version' do
          expect(subject.version).to eq(1)
          expect(subject.main_class).to eq(TestVersionedWorkflow)
          expect(subject.version_class).to eq(TestVersionedWorkflowV1)
          expect(TestVersionedWorkflow).not_to have_received(:pick_version)
        end
      end

      context 'when passed a non-existing version' do
        let(:version) { 3 }

        it 'raises UnknownWorkflowVersion' do
          expect { subject }.to raise_error(
            Cadence::Concerns::Versioned::UnknownWorkflowVersion,
            'Unknown version 3 for TestVersionedWorkflow'
          )
          expect(TestVersionedWorkflow).not_to have_received(:pick_version)
        end
      end
    end

    context 'when version does not override the attributes' do
      let(:version) { 1 }

      before { allow(subject).to receive(:warn) }

      describe '#domain' do
        it 'returns default version domain' do
          expect(subject.domain).to eq('domain')
          expect(subject).not_to have_received(:warn)
        end
      end

      describe '#task_list' do
        it 'returns default version task_list' do
          expect(subject.task_list).to eq('task-list')
          expect(subject).not_to have_received(:warn)
        end
      end

      describe '#retry_policy' do
        it 'returns default version retry_policy' do
          expect(subject.retry_policy).to eq(interval: 1, backoff: 2, max_attempts: 5)
        end
      end

      describe '#timeouts' do
        it 'returns default version timeouts' do
          expect(subject.timeouts).to eq(start_to_close: 10)
        end
      end

      describe '#headers' do
        it 'returns default version headers including version header' do
          expect(subject.headers).to eq(
            'HeaderA' => 'TestA',
            'HeaderB' => 'TestB',
            Cadence::Concerns::Versioned::VERSION_HEADER_NAME => '1'
          )
        end
      end
    end

    context 'when version overwrites the attribute' do
      let(:version) { 2 }

      before { allow(subject).to receive(:warn) }

      describe '#domain' do
        it 'returns default version domain and warns' do
          expect(subject.domain).to eq('domain')
          expect(subject)
            .to have_received(:warn)
            .with('[WARNING] Overriding domain in a workflow version is not yet supported. ' \
                  'Called from TestVersionedWorkflowV2.')
        end
      end

      describe '#task_list' do
        it 'returns default version task_list and warns' do
          expect(subject.task_list).to eq('task-list')
          expect(subject)
            .to have_received(:warn)
            .with('[WARNING] Overriding task_list in a workflow version is not yet supported. ' \
                  'Called from TestVersionedWorkflowV2.')
        end
      end

      describe '#retry_policy' do
        it 'returns overriden retry_policy' do
          expect(subject.retry_policy).to eq(interval: 5, backoff: 1, max_attempts: 2)
        end
      end

      describe '#timeouts' do
        it 'returns overriden timeouts' do
          expect(subject.timeouts).to eq(execution: 1)
        end
      end

      describe '#headers' do
        it 'returns overriden headers including version header' do
          expect(subject.headers).to eq(
            'HeaderV2' => 'TestV2',
            Cadence::Concerns::Versioned::VERSION_HEADER_NAME => '2'
          )
        end
      end
    end
  end

  describe described_class::ClassMethods do
    subject { TestVersionedWorkflow }

    describe '.version' do
      after { TestVersionedWorkflow.send(:versions).delete(4) }

      it 'adds a new version' do
        subject.version(4, TestVersionedWorkflowV1)

        expect(subject.version_class_for(4)).to eq(TestVersionedWorkflowV1)
      end
    end

    describe '.execute_in_context' do
      let(:context) { instance_double(Cadence::Workflow::Context, headers: headers) }

      context 'when called with a non-default version' do
        let(:headers) { { Cadence::Concerns::Versioned::VERSION_HEADER_NAME => '2' } }
        before { allow(TestVersionedWorkflowV2).to receive(:execute_in_context) }

        it 'calls version' do
          subject.execute_in_context(context, nil)

          expect(TestVersionedWorkflowV2).to have_received(:execute_in_context).with(context, nil)
        end
      end
    end

    describe '.version_class_for' do
      context 'when given a valid version' do
        it 'returns version class' do
          expect(subject.version_class_for(2)).to eq(TestVersionedWorkflowV2)
        end
      end

      context 'when given a default version' do
        it 'returns default version class' do
          expect(subject.version_class_for(Cadence::Concerns::Versioned::DEFAULT_VERSION))
            .to eq(TestVersionedWorkflow)
        end
      end

      context 'when given an invalid version' do
        it 'raises UnknownWorkflowVersion' do
          expect { subject.version_class_for(3) }.to raise_error(
            Cadence::Concerns::Versioned::UnknownWorkflowVersion,
            'Unknown version 3 for TestVersionedWorkflow'
          )
        end
      end
    end

    describe '.pick_version' do
      class TestPickVersionWorkflow < Cadence::Workflow
        include Cadence::Concerns::Versioned

        version_picker { |latest_version| latest_version + 42 }
      end

      context 'when using default version picker' do
        it 'returns the latest version' do
          expect(TestVersionedWorkflow.pick_version).to eq(2)
        end
      end

      context 'when using overriden version picker' do
        it 'returns a custom version' do
          expect(TestPickVersionWorkflow.pick_version).to eq(42)
        end
      end
    end
  end
end
