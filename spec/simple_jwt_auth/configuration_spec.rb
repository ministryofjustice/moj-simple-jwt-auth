# frozen_string_literal: true

RSpec.describe SimpleJwtAuth::Configuration do
  let(:config) { SimpleJwtAuth.configuration }

  describe '#logger' do
    context 'when no logger is specified' do
      it 'has a default to logger' do
        expect(config.logger).to be_a(::Logger)
      end
    end

    context 'when an logger is specified' do
      let(:custom_value) { Object.new }

      before do
        SimpleJwtAuth.configure { |config| config.logger = custom_value }
      end

      it 'returns configured value' do
        expect(config.logger).to eq(custom_value)
      end
    end
  end

  describe '#exp_seconds' do
    context 'when no exp_seconds is specified' do
      it 'has a default value' do
        expect(config.exp_seconds).to eq(30)
      end
    end

    context 'when a custom exp_seconds is specified' do
      let(:custom_value) { 120 }

      before do
        SimpleJwtAuth.configure { |config| config.exp_seconds = custom_value }
      end

      it 'returns configured value' do
        expect(config.exp_seconds).to eq(custom_value)
      end
    end
  end

  describe '#exp_leeway' do
    context 'when no exp_leeway is specified' do
      it 'has a default value' do
        expect(config.exp_leeway).to eq(10)
      end
    end

    context 'when a custom exp_leeway is specified' do
      let(:custom_value) { 30 }

      before do
        SimpleJwtAuth.configure { |config| config.exp_leeway = custom_value }
      end

      it 'returns configured value' do
        expect(config.exp_leeway).to eq(custom_value)
      end
    end
  end

  describe '#algorithm' do
    context 'when no algorithm is specified' do
      it 'has a default value' do
        expect(config.algorithm).to eq('HS256')
      end
    end

    context 'when a custom algorithm is specified' do
      let(:custom_value) { 'HS512' }

      before do
        SimpleJwtAuth.configure { |config| config.algorithm = custom_value }
      end

      it 'returns configured value' do
        expect(config.algorithm).to eq(custom_value)
      end
    end
  end

  describe '#issuer' do
    context 'when no issuer is specified' do
      it 'returns nil' do
        expect(config.issuer).to be_nil
      end
    end

    context 'when an issuer is specified' do
      let(:custom_value) { 'MyAppName' }

      before do
        SimpleJwtAuth.configure { |config| config.issuer = custom_value }
      end

      it 'returns configured value' do
        expect(config.issuer).to eq(custom_value)
      end
    end
  end

  describe '#secrets_config' do
    context 'when no secrets_config is specified' do
      it 'returns an empty hash' do
        expect(config.secrets_config).to eq({})
      end
    end

    context 'when secrets_config is specified' do
      let(:custom_value) { { 'foo' => 'bar' } }

      before do
        SimpleJwtAuth.configure { |config| config.secrets_config = custom_value }
      end

      it 'returns configured value' do
        expect(config.secrets_config).to eq(custom_value)
      end
    end
  end
end
