require 'cadence/workflow'
require 'shared_examples/an_executable'

describe Cadence::Workflow do
  it_behaves_like 'an executable'

  describe '.execute_in_context' do
    subject { described_class.new(new_context) }
    let(:new_context) { instance_double('Cadence::Workflow::Context') }
    let(:thread_context_mock) { class_double(Cadence::ThreadLocalContext) }
    let(:input) { [] }

    before do
      allow(described_class).to receive(:new).and_return(subject)
      allow(subject).to receive(:execute).and_return('result')
      allow(new_context).to receive(:complete)
      allow(Cadence::ThreadLocalContext).to receive(:set)
      allow(Cadence::ThreadLocalContext).to receive(:get).and_return(previous_context)
    end

    context 'when a previous context exists' do
      let(:previous_context) { instance_double('Cadence::Workflow::Context') }

      it 'resets the context' do
        described_class.execute_in_context(new_context, input)
        expect(Cadence::ThreadLocalContext).to have_received(:get).ordered
        expect(Cadence::ThreadLocalContext).to have_received(:set).with(new_context).ordered
        expect(new_context).to have_received(:complete).ordered
        expect(Cadence::ThreadLocalContext).to have_received(:set).with(previous_context).ordered
      end

      context 'when a failure is raised' do
        before do
          allow(described_class).to receive(:new).and_raise(StandardError)
          allow(new_context).to receive(:metadata).and_return('metadata')
          allow(new_context).to receive(:fail)
        end

        it 'resets the context' do
          described_class.execute_in_context(new_context, input)
          expect(Cadence::ThreadLocalContext).to have_received(:get).ordered
          expect(Cadence::ThreadLocalContext).to have_received(:set).with(new_context).ordered
          expect(new_context).to have_received(:fail).ordered
          expect(Cadence::ThreadLocalContext).to have_received(:set).with(previous_context).ordered
        end
      end
    end

    context 'when the previous context does not exist' do
      let(:previous_context) { nil }

      it 'does not reset context' do
        described_class.execute_in_context(new_context, input)
        expect(Cadence::ThreadLocalContext).to have_received(:get).ordered
        expect(Cadence::ThreadLocalContext).to have_received(:set).once.with(new_context).ordered
        expect(new_context).to have_received(:complete).ordered
        expect(Cadence::ThreadLocalContext).not_to have_received(:set).with(previous_context)
      end
    end
  end
end
