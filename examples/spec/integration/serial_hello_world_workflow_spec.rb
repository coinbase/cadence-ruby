require 'workflows/serial_hello_world_workflow'

describe SerialHelloWorldWorkflow, :integration do
  it 'completes' do
    result = run_workflow(described_class, 'Alice', 'Bob', 'John')

    expect(result.events.first.type).to eq('WorkflowExecutionCompleted')
  end
end
