require 'workflows/versioned_workflow'
require 'cadence/json'

describe VersionedWorkflow, :integration do
  context 'when scheduling' do
    context 'without explicit version' do
      it 'executes the latest version' do
        result = run_workflow(described_class)

        event = result.events.first

        expect(event.type).to eq('WorkflowExecutionCompleted')
        expect(Cadence::JSON.deserialize(event.attributes.result)).to eq('ECHO: version 2')
      end
    end

    context 'with explicit version' do
      let(:options) { { options: { headers: { 'Version' => '1' } } } }

      it 'executes the specified version' do
        result = run_workflow(described_class, options)

        event = result.events.first

        expect(event.type).to eq('WorkflowExecutionCompleted')
        expect(Cadence::JSON.deserialize(event.attributes.result)).to eq('ECHO: version 1')
      end
    end

    context 'with a non-existing version' do
      let(:options) { { options: { headers: { 'Version' => '3' } } } }

      it 'raises an error' do
        expect do
          run_workflow(described_class, options)
        end.to raise_error(
          Cadence::Concerns::Versioned::UnknownWorkflowVersion,
          'Unknown version 3 for VersionedWorkflow'
        )
      end
    end
  end

  context 'when already scheduled' do
    context 'without a version' do
      it 'executes the default version' do
        # starting with a plain string to skip the automatic header setting
        result = run_workflow('VersionedWorkflow')

        event = result.events.first

        expect(event.type).to eq('WorkflowExecutionCompleted')
        expect(Cadence::JSON.deserialize(event.attributes.result)).to eq('ECHO: default version')
      end
    end

    context 'with a non-existing version' do
      let(:options) do
        {
          options: {
            timeouts: { execution: 1 },
            headers: { 'Version' => '3' }
          }
        }
      end

      it 'times out the workflow' do
        result = run_workflow('VersionedWorkflow', options)

        event = result.events.first

        expect(event.type).to eq('WorkflowExecutionTimedOut')
      end
    end
  end
end
