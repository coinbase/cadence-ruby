require 'cadence/testing/local_workflow_context'
require 'cadence/workflow/context'
require 'cadence/workflow/dispatcher'

describe Cadence::Workflow::Context do
    let(:state_manager) { instance_double('Cadence::Workflow::StateManager') }
    let(:dispatcher) { Cadence::Workflow::Dispatcher.new }
    let(:metadata_hash) do 
        {name: 'TestWorkflow', run_id: SecureRandom.uuid, attempt: 0}
    end
    let(:metadata) { Cadence::Metadata::Workflow.new(metadata_hash) }
    let(:context) { described_class.new(state_manager, dispatcher, metadata) }

    describe '.sleep_until' do
        let(:start_time) { Time.now}
        let(:end_time) { Time.now + 1}
        let(:delay_time) { (end_time-start_time).to_i }

        before do
            allow(state_manager).to receive(:local_time).and_return(start_time)
            allow(context).to receive(:sleep)
        end

        it 'sleeps until the given end_time' do
            context.sleep_until(end_time)
            # Since sleep_until uses, sleep, just make sure that sleep is called with the delay_time
            expect(context).to have_received(:sleep).with(delay_time)
        end
    end
end
