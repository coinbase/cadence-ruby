require 'cadence/fiber_with_parent_locals'

describe Cadence::FiberWithParentLocals do
  subject { described_class }

  after { Thread.current[:test_key] = nil }

  describe '.new' do

    context 'it copies and clones' do
      before { Thread.current[:test_key] = :test_value }

      it 'it copies and clones' do
        test_var = nil
        subject.new do
          test_var = Thread.current[:test_key]
        end.resume

        expect(test_var).to eq(:test_value)
      end
    end

    context 'modifying parent variables' do
      let(:test_value) { { test: :value } }
      before do
        allow(test_value).to(receive(:clone).and_call_original)
        Thread.current[:test_key] = test_value
      end

      it 'copies parent thread variables' do
        test_var = nil
        subject.new do
          test_var = Thread.current[:test_key]
          test_var[:did_clone] = :cloned
        end.resume

        expect(test_value).to(eq({ test: :value }))
        expect(test_var).to(include({ test: :value, did_clone: :cloned}))
      end

      it 'calls clone on parent variables' do
        subject.new {}.resume

        expect(test_value).to(have_received(:clone))
      end

      it 'holds a different object id from parent variable' do
        test_id = nil
        subject.new do
          test_id = Thread.current[:test_key].object_id
        end.resume

        expect(test_id).not_to(eq(test_value.object_id))
      end
    end


  end
end
