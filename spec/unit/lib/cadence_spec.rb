require 'cadence'

describe Cadence do
  describe 'public method forwarding' do
    let(:client) { instance_double(Cadence::Client) }

    before { allow(Cadence::Client).to receive(:new).and_return(client) }
    after { described_class.remove_instance_variable(:@default_client) }

    shared_examples 'a forwarded method' do |method, *args, **kwargs|
      it 'forwards mehod call to the default client instance' do
        allow(client).to receive(method)

        described_class.public_send(method, *args, **kwargs)

        expect(client).to have_received(method).with(*args, **kwargs)
      end
    end

    describe '.start_workflow' do
      it_behaves_like 'a forwarded method', :start_workflow, 'TestWorkflow', 42
    end

    describe '.schedule_workflow' do
      it_behaves_like 'a forwarded method', :schedule_workflow, 'TestWorkflow', '* * * * *', 42
    end

    describe '.register_domain' do
      it_behaves_like 'a forwarded method', :register_domain, 'test-domain', 'This is a test domain'
    end

    describe '.signal_workflow' do
      it_behaves_like 'a forwarded method', :signal_workflow, 'TestWorkflow', 'TST_SIGNAL', 'x', 'y'
    end

    describe '.reset_workflow' do
      it_behaves_like 'a forwarded method', :reset_workflow, 'test-domain', 'x', 'y'
    end

    describe '.terminate_workflow' do
      it_behaves_like 'a forwarded method', :terminate_workflow, 'test-domain', 'x', 'y'
    end

    describe '.fetch_workflow_execution_info' do
      it_behaves_like 'a forwarded method', :fetch_workflow_execution_info, 'test-domain', 'x', 'y'
    end

    describe '.complete_activity' do
      it_behaves_like 'a forwarded method', :complete_activity, 'test-token', 'result'
    end

    describe '.fail_activity' do
      it_behaves_like 'a forwarded method', :complete_activity, 'test-token', StandardError.new
    end

    describe '.get_workflow_history' do
      it_behaves_like 'a forwarded method',
        :get_workflow_history, domain: 'test-domain', workflow_id: 'x', run_id: 'y'
    end
  end

  describe '.configure' do
    it 'calls a block with the configuration' do
      expect do |block|
        described_class.configure(&block)
      end.to yield_with_args(described_class.configuration)
    end
  end

  describe '.configuration' do
    it 'returns Cadence::Configuration object' do
      expect(described_class.configuration).to be_an_instance_of(Cadence::Configuration)
    end
  end

  describe '.logger' do
    it 'returns preconfigured Cadence logger' do
      expect(described_class.logger).to eq(described_class.configuration.logger)
    end
  end

  describe '.metrics' do
    it 'returns preconfigured Cadence metrics' do
      expect(described_class.metrics).to an_instance_of(Cadence::Metrics)
    end
  end
end
