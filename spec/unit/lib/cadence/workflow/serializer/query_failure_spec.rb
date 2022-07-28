require 'cadence/workflow/serializer/query_failure'
require 'cadence/workflow/query_result'

describe Cadence::Workflow::Serializer::QueryFailure do
  describe 'to_proto' do
    let(:exception) { StandardError.new('Test query failure') }
    let(:query_result) { Cadence::Workflow::QueryResult.failure(exception) }

    it 'produces a protobuf' do
      result = described_class.new(query_result).to_proto

      expect(result).to be_a(CadenceThrift::WorkflowQueryResult)
      expect(result.result_type).to eq(CadenceThrift::QueryResultType.lookup(
        CadenceThrift::QueryResultType::FAILED)
                                    )
      expect(result.error_message).to eq('Test query failure')
    end
  end
end