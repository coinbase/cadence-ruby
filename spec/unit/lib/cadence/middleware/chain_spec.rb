require 'cadence/middleware/chain'

describe Cadence::Middleware::Chain do
  subject { described_class.new([ChangeNameMiddleware]) }
  let(:broken_subject) { described_class.new([BrokenMiddleware]) }
  let(:test_task) { TestTask.new('hello world') }


  class TestTask
    def initialize(name)
      @name = name
    end
    attr_accessor :name
  end

  class ChangeNameMiddleware < Cadence::Middleware
    def call(task, &next_middleware)
      task.name = 'test'
      return next_middleware.call(task)
    end
  end

  class BrokenMiddleware < Cadence::Middleware
    def call(task, &next_middleware)
      task.name = 'test'
      # Does not call next middleware, :grimace:
      return nil
    end
  end

  describe '#invoke' do
    it 'returns the modified task name' do
      result = subject.invoke(test_task) { |task| task }
      expect(result.name).to eq('test')
    end

    it 'only allows single argument blocks to be passed' do
      result = broken_subject.invoke(test_task) { |task| task }
      print(result)
    end
  end

  describe '#init_middlewares' do
    it 'returns a map of initialized middlewares' do
      subject.send(:init_middlewares).each do |m|
        expect(m.kind_of? Cadence::Middleware).to eq(true)
      end
    end
  end
end
