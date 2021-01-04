require 'cadence/fiber_with_parent_locals'

describe Cadence::FiberWithParentLocals do
  subject { described_class }

  after { Thread.current[:test_key] = nil }

  describe '.new' do
    let(:test_value) { { test: :hash } }
    before { Thread.current[:test_key] = test_value }

    it 'copies and does not modify parent thread variables' do
      test_var = nil
      subject.new do
        test_var = Thread.current[:test_key]
        test_var[:did_clone] = :cloned
      end.resume

      expect(test_value).to(eq({ test: :hash }))
      expect(test_var).to(eq({ did_clone: :cloned, test: :hash }))
    end
  end
end
