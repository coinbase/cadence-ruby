require 'cadence/error_handler'

describe Cadence::ErrorHandler do
  subject { described_class }
  let(:config) { Cadence::Configuration.new }
  let(:test_error) { StandardError.new('test error') }
  let(:decision_metadata) { Fabricate(:decision_metadata) }

  before do
    allow(Cadence).to receive(:configuration).and_return(config)
    allow(Cadence.logger).to receive(:error)
  end

  describe '.handle' do
    context 'when there are error handlers' do
      let(:handler_1) { lambda { |_error, _metadata| } }
      let(:handler_2) { lambda { |_error, _metadata| } }

      before do
        config.on_error(&handler_1)
        config.on_error(&handler_2)
      end

      it 'calls handlers' do
        allow(handler_1).to receive(:call).and_call_original
        allow(handler_2).to receive(:call).and_call_original

        subject.handle(test_error, metadata: decision_metadata)

        expect(handler_1)
          .to have_received(:call)
          .ordered
          .with(test_error, decision_metadata)

        expect(handler_2)
          .to have_received(:call)
          .ordered
          .with(test_error, decision_metadata)
      end

      it 'does not call logger' do
        subject.handle(test_error, metadata: decision_metadata)

        expect(Cadence.logger).not_to have_received(:error)
      end

      context 'when called without metadata' do
        it 'calls handlers' do
          allow(handler_1).to receive(:call).and_call_original
          allow(handler_2).to receive(:call).and_call_original

          subject.handle(test_error)

          expect(handler_1).to have_received(:call).ordered.with(test_error, nil)
          expect(handler_2).to have_received(:call).ordered.with(test_error, nil)
        end

        it 'does not call logger' do
          subject.handle(test_error)

          expect(Cadence.logger).not_to have_received(:error)
        end
      end
    end

    context 'when one of the error handlers raises' do
      let(:handler) { lambda { |error, metadata| raise 'handler failure' } }

      before { config.on_error(&handler) }

      it 'logs failure' do
        allow(handler).to receive(:call).and_call_original

        subject.handle(test_error, metadata: decision_metadata)

        expect(Cadence.logger)
          .to have_received(:error)
          .with('Error handler failed: #<RuntimeError: handler failure>')

        expect(handler).to have_received(:call).with(test_error, decision_metadata)
      end
    end
  end
end
