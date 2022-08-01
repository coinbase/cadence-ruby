require 'cadence/workflow/serializer/query_failure'
require 'cadence/workflow/query_result'

describe Cadence::Workflow::Serializer::QueryFailure do
  describe 'to_thrift' do
    let(:exception) { StandardError.new('Test query failure') }
    let(:query_result) { Cadence::Workflow::QueryResult.failure(exception) }

    it 'produces a thrift object' do
      result = described_class.new(query_result).to_thrift

      expect(result).to be_a(CadenceThrift::WorkflowQueryResult)
      expect(result.resultType).to eq(CadenceThrift::QueryResultType::FAILED
                                   )
      expect(result.errorReason).to eq('Test query failure')
    end
  end
end