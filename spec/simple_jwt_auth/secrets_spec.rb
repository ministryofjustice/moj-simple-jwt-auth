# frozen_string_literal: true

RSpec.describe SimpleJwtAuth::Secrets do
  subject { described_class.new(secrets_config) }

  let(:secrets_config) { { 'foo' => 'bar', 'my_app' => 'secret' } }

  describe '#issuers' do
    it 'returns a list of configured issuers' do
      expect(subject.issuers).to eq(%w[foo my_app])
    end
  end

  describe '#secret_for' do
    context 'for a nil issuer' do
      it 'raises an error' do
        expect {
          subject.secret_for(nil)
        }.to raise_error(SimpleJwtAuth::Errors::UndefinedIssuer, /issuer has not been configured/)
      end
    end

    context 'for an unrecognized issuer' do
      it 'raises an error' do
        expect {
          subject.secret_for('dunno')
        }.to raise_error(SimpleJwtAuth::Errors::UnknownIssuer, /issuer `dunno` is not recognized/)
      end
    end

    context 'for an existing issuer' do
      it 'returns the associated secret' do
        expect(subject.secret_for('my_app')).to eq('secret')
      end
    end
  end
end
