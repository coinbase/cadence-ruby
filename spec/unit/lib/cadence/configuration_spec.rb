require 'cadence/configuration'

describe Cadence::Configuration do
  subject { described_class.new }

  describe '#on_error' do
    let(:handler_1) { lambda { } }
    let(:handler_2) { lambda { } }

    it 'adds a new error handler' do
      subject.on_error(&handler_1)
      subject.on_error(&handler_2)

      expect(subject.error_handlers).to eq([handler_1, handler_2])
    end
  end
end
