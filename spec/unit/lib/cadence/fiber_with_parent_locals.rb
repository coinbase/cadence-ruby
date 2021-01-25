require 'cadence/fiber_with_parent_locals'

describe Cadence::FiberWithParentLocals do
  subject { described_class }

  after { Thread.current[:test_key] = nil }

  describe '.new' do
    before { Thread.current[:test_key] = :test_value }

    it 'copies parent thread variables' do
      test_var = nil
      subject.new do
        test_var = Thread.current[:test_key]
      end.resume

      expect(test_var).to eq(:test_value)
    end
  end
end
