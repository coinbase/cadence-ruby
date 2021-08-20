require 'cadence/metadata/workflow'

describe Cadence::Metadata::Workflow do
  subject { described_class.new(args.to_h) }
  let(:args) { Fabricate(:workflow_metadata) }

  describe '#initialize' do
    it 'sets the attributes' do
      expect(subject.domain).to eq(args.domain)
      expect(subject.id).to eq(args.id)
      expect(subject.name).to eq(args.name)
      expect(subject.run_id).to eq(args.run_id)
      expect(subject.attempt).to eq(args.attempt)
      expect(subject.headers).to eq(args.headers)
      expect(subject.timeouts).to eq(args.timeouts)
    end

    it { is_expected.to be_frozen }
    it { is_expected.not_to be_activity }
    it { is_expected.not_to be_decision }
    it { is_expected.to be_workflow }
  end

  describe '#to_h' do
    it 'returns a hash' do
      expect(subject.to_h).to eq(
        domain: subject.domain,
        workflow_id: subject.id,
        attempt: subject.attempt,
        workflow_name: subject.name,
        workflow_run_id: subject.run_id
      )
    end
  end
end
