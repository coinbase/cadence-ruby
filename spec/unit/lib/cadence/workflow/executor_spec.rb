require 'cadence/workflow/executor'
require 'cadence/workflow/history'
require 'cadence/workflow'
require 'cadence/workflow/decision_task_processor'
require 'cadence/workflow/query_registry'

describe Cadence::Workflow::Executor do
  subject { described_class.new(workflow, history, decision_metadata, config) }

  let(:workflow_started_event) { Fabricate(:workflow_execution_started_event_thrift, eventId: 1) }
  let(:history) do
    Cadence::Workflow::History.new([
                                     workflow_started_event,
                                     Fabricate(:decision_task_scheduled_event_thrift, eventId: 2),
                                     Fabricate(:decision_task_started_event_thrift, eventId: 3),
                                     Fabricate(:decision_task_completed_event_thrift, eventId: 4)
                                   ])
  end
  let(:workflow) { TestWorkflow }
  let(:decision_metadata) { Fabricate(:decision_metadata) }
  let(:config) { Cadence::Configuration.new }

  class TestWorkflow < Cadence::Workflow
    def execute
      'test'
    end
  end

  describe '#run' do
    it 'runs a workflow' do
      allow(workflow).to receive(:execute_in_context).and_call_original

      subject.run

      expect(workflow)
        .to have_received(:execute_in_context)
              .with(
                an_instance_of(Cadence::Workflow::Context),
                nil
              )
    end

    it 'returns a complete workflow decision' do
      decisions = subject.run

      expect(decisions.length).to eq(1)

      decision_id, decision = decisions.first
      expect(decision_id).to eq(history.events.length + 1)
      expect(decision).to be_an_instance_of(Cadence::Workflow::Decision::CompleteWorkflow)
      expect(decision.result).to eq('test')
    end

    it 'generates workflow metadata' do
      allow(Cadence::Metadata::Workflow).to receive(:new).and_call_original
      workflow_started_event.workflowExecutionStartedEventAttributes.header =
        Fabricate(:header_thrift, fields: { 'Foo' => 'Bar' })

      subject.run

      event_attributes = workflow_started_event.workflowExecutionStartedEventAttributes
      expect(Cadence::Metadata::Workflow)
        .to have_received(:new)
              .with(
                domain: decision_metadata.domain,
                id: decision_metadata.workflow_id,
                name: event_attributes.workflowType.name,
                run_id: event_attributes.originalExecutionRunId,
                attempt: event_attributes.attempt,
                headers: { 'Foo' => 'Bar' },
                timeouts: {
                  execution: event_attributes.executionStartToCloseTimeoutSeconds,
                  task: event_attributes.taskStartToCloseTimeoutSeconds
                }
              )
    end
  end

  describe '#process_queries' do
    let(:query_registry) { Cadence::Workflow::QueryRegistry.new }
    let(:query_1_result) { 42 }
    let(:query_2_error) { StandardError.new('Test query failure') }
    let(:queries) do
      {
        '1' => Cadence::Workflow::DecisionTaskProcessor::Query.new(Fabricate(:api_workflow_query, queryType: 'success')),
        '2' => Cadence::Workflow::DecisionTaskProcessor::Query.new(Fabricate(:api_workflow_query, queryType: 'failure')),
        '3' => Cadence::Workflow::DecisionTaskProcessor::Query.new(Fabricate(:api_workflow_query, queryType: 'unknown')),
      }
    end

    before do
      allow(Cadence::Workflow::QueryRegistry).to receive(:new).and_return(query_registry)
      query_registry.register('success') { query_1_result }
      query_registry.register('failure') { raise query_2_error }
    end

    it 'returns query results' do
      results = subject.process_queries(queries)
      expect(results.length).to eq(3)
      expect(results['1']).to be_a(Cadence::Workflow::QueryResult::Answer)
      expect(results['1'].result).to eq(query_1_result)
      expect(results['2']).to be_a(Cadence::Workflow::QueryResult::Failure)
      expect(results['2'].error).to eq(query_2_error)
      expect(results['3']).to be_a(Cadence::Workflow::QueryResult::Failure)
      expect(results['3'].error).to be_a(Cadence::QueryFailed)
      expect(results['3'].error.message).to eq('Workflow did not register a handler for unknown')
    end
  end
end



