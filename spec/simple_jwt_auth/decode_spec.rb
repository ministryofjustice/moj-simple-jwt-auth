# frozen_string_literal: true

RSpec.describe SimpleJwtAuth::Decode do
  subject { described_class.new(token, options) }

  let(:token) { nil }
  let(:options) { {} }

  before do
    SimpleJwtAuth.configure do |config|
      config.issuer = 'TestApp'
      config.secrets_config = { 'TestApp' => 'secret' }
    end

    allow(Time).to receive(:now).and_return(Time.new(2023, 01, 01))
  end

  describe '#call' do
    let(:token) { SimpleJwtAuth::Encode.new.call }

    it 'decodes a valid JWT token' do
      expect {
        subject.call
      }.not_to raise_error
    end

    context 'when there is no configured secret for issuer' do
      let(:token) { SimpleJwtAuth::Encode.new(claims: { iss: 'dunno' }).call }

      it 'raises an error' do
        expect {
          subject.call
        }.to raise_error(SimpleJwtAuth::Errors::UnknownIssuer)
      end
    end

    context 'default decoding options' do
      let(:expected_options) do
        {
          required_claims: %w[iss iat exp],
          algorithm: 'HS256',
          exp_leeway: 10,
          nbf_leeway: 10,
          iss: ['TestApp'],
          verify_iss: true,
          verify_iat: true,
        }
      end

      it 'has the default options' do
        expect(JWT).to receive(:decode).with(
          token, nil, true, expected_options
        )

        subject.call
      end
    end

    context 'additional decoding options' do
      let(:options) { { verify_not_before: false } }

      it 'allows to pass additional options' do
        expect(JWT).to receive(:decode).with(
          token, nil, true, hash_including(verify_not_before: false)
        )

        subject.call
      end
    end
  end
end
