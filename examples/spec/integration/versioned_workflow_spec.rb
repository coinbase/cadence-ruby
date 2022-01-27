require 'workflows/versioned_workflow'

describe VersionedWorkflow, :integration do
  context 'without explicit version' do
    it 'executes latest version' do
      result = run_workflow(described_class)

      event = result.history.events.first

      expect(event.eventType).to eq(CadenceThrift::EventType::WorkflowExecutionCompleted)
      expect(event.result).to eq('ECHO: version 2')
    end
  end

  context 'with explicit version' do
    it 'executes specified version' do
      result = run_workflow(described_class, options: { headers: { 'Version' => '1' }})

      event = result.history.events.first

      expect(event.eventType).to eq(CadenceThrift::EventType::WorkflowExecutionCompleted)
      expect(event.result).to eq('ECHO: version 1')
    end
  end

  context 'with a missing version' do
    it 'executes default version' do
      result = run_workflow(described_class, options: { headers: { 'Version' => nil }})

      event = result.history.events.first

      expect(event.eventType).to eq(CadenceThrift::EventType::WorkflowExecutionCompleted)
      expect(event.result).to eq('ECHO: default version')
    end
  end
end
