shared_examples 'an executable' do
  describe '.domain' do
    after { described_class.remove_instance_variable(:@domain) }

    it 'gets current domain' do
      described_class.instance_variable_set(:@domain, :test)

      expect(described_class.domain).to eq(:test)
    end

    it 'sets new domain' do
      described_class.domain(:test)

      expect(described_class.instance_variable_get(:@domain)).to eq(:test)
    end
  end

  describe '.task_list' do
    after { described_class.remove_instance_variable(:@task_list) }

    it 'gets current task list' do
      described_class.instance_variable_set(:@task_list, :test)

      expect(described_class.task_list).to eq(:test)
    end

    it 'sets new task list' do
      described_class.task_list(:test)

      expect(described_class.instance_variable_get(:@task_list)).to eq(:test)
    end
  end

  describe '.retry_policy' do
    after { described_class.remove_instance_variable(:@retry_policy) }

    it 'gets current retry policy' do
      described_class.instance_variable_set(:@retry_policy, :test)

      expect(described_class.retry_policy).to eq(:test)
    end

    it 'sets new valid retry policy' do
      described_class.retry_policy(:test)

      expect(described_class.instance_variable_get(:@retry_policy)).to eq(:test)
    end
  end

  describe '.timeouts' do
    after { described_class.remove_instance_variable(:@timeouts) }

    it 'gets current timeouts' do
      described_class.instance_variable_set(:@timeouts, :test)

      expect(described_class.timeouts).to eq(:test)
    end

    it 'sets new timeouts' do
      described_class.timeouts(:test)

      expect(described_class.instance_variable_get(:@timeouts)).to eq(:test)
    end
  end
end
