require 'cadence/workflow/serializer/query_failure'
require 'cadence/workflow/query_result'
require 'cadence/workflow/serializer/query_answer'

describe Cadence::Workflow::Serializer::QueryAnswer do
  class TestDeserializer
  end

  describe 'to_thrift' do
    let(:query_result) { Cadence::Workflow::QueryResult.answer(42) }
    it 'produces a thrift object' do
      result = described_class.new(query_result).to_thrift

      expect(result).to be_a(CadenceThrift::WorkflowQueryResult)
      expect(result.resultType).to eq(CadenceThrift::QueryResultType::ANSWERED
                                   )
      expect(result.answer).to eq("42")
    end
  end
end