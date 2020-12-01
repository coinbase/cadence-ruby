require 'cadence/saga/compensable'

describe Cadence::Saga::Compensable do
  class Compensable
    extend Cadence::Saga::Compensable
  end

  context '.compensable_errors' do
    after { Compensable.remove_instance_variable(:@compensable_errors) }

    it 'gets current compensable_errors' do
      Compensable.instance_variable_set(:@compensable_errors, :test)

      expect(Compensable.compensable_errors).to eq(:test)
    end

    it 'sets new compensable_errors' do
      Compensable.compensable_errors(:test)

      expect(Compensable.instance_variable_get(:@compensable_errors)).to eq(:test)
    end
  end

  context '.non_compensable_errors' do
    after { Compensable.remove_instance_variable(:@non_compensable_errors) }

    it 'gets current non_compensable_errors' do
      Compensable.instance_variable_set(:@non_compensable_errors, :test)

      expect(Compensable.non_compensable_errors).to eq(:test)
    end

    it 'sets new non_compensable_errors' do
      Compensable.non_compensable_errors(:test)

      expect(Compensable.instance_variable_get(:@non_compensable_errors)).to eq(:test)
    end
  end

  context '.compensable?' do
    class CompensableAllowedError < StandardError; end;
    class CompensableDisallowedError < StandardError; end;
    it 'is compensable if no errors set' do
      expect(Compensable.compensable?(CompensableDisallowedError.new)).to be_truthy
    end

    describe 'compensable_errors' do
      after { Compensable.remove_instance_variable(:@compensable_errors) }

      it 'is compensable if error in whitelist' do
        
        Compensable.compensable_errors([CompensableAllowedError])
  
        expect(Compensable.compensable?(CompensableAllowedError.new('error'))).to be_truthy
      end
  
      it 'is not compensable if error is not in allowed list' do
        class CompensableWhitelistError < StandardError; end;
        Compensable.compensable_errors([CompensableAllowedError])
  
        expect(Compensable.compensable?(CompensableDisallowedError.new('error'))).to be_falsey
      end
    end

    describe 'non_compensable_errors' do
      after { Compensable.remove_instance_variable(:@non_compensable_errors) }

      it 'is compensable if error is not in excluded list' do
        class CompensableBlacklistError < StandardError; end;
        Compensable.non_compensable_errors([CompensableDisallowedError])
  
        expect(Compensable.compensable?(CompensableAllowedError.new('error'))).to be_truthy
      end
  
      it 'is not compensable if error is excluded list' do
        class CompensableWhitelistError < StandardError; end;
        Compensable.non_compensable_errors([CompensableDisallowedError])
  
        expect(Compensable.compensable?(CompensableDisallowedError.new('error'))).to be_falsey
      end
    end
  end
end
