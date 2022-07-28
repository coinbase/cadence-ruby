require 'cadence/workflow/serializer/query_failure'
require 'cadence/workflow/query_result'
require 'cadence/workflow/serializer/query_answer'

describe Cadence::Workflow::Serializer::QueryAnswer do
  class TestDeserializer
  end

  describe 'to_proto' do
    let(:query_result) { Cadence::Workflow::QueryResult.answer(42) }
    it 'produces a protobuf' do
      result = described_class.new(query_result).to_proto

      expect(result).to be_a(CadenceThrift::WorkflowQueryResult)
      expect(result.result_type).to eq(CadenceThrift::QueryResultType.lookup(
        CadenceThrift::QueryResultType::ANSWERED)
                                    )
      expect(result.answer).to eq(JSON.serialize(42))
    end
  end
end