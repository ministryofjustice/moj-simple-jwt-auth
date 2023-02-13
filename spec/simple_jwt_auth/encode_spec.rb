# frozen_string_literal: true

RSpec.describe SimpleJwtAuth::Encode do
  subject { described_class.new(**kwargs) }

  let(:kwargs) { {} }

  before do
    SimpleJwtAuth.configure do |config|
      config.issuer = 'TestApp'
      config.secrets_config = { 'TestApp' => 'secret' }
    end

    allow(Time).to receive(:now).and_return(Time.new(2023, 01, 01))
  end

  describe '#call' do
    it 'generates a valid JWT token' do
      expect {
        SimpleJwtAuth::Decode.new(subject.call).call
      }.not_to raise_error
    end

    context 'when there is no configured secret for issuer' do
      let(:kwargs) { { claims: { iss: 'dunno' }} }

      it 'raises an error' do
        expect {
          subject.call
        }.to raise_error(SimpleJwtAuth::Errors::UnknownIssuer)
      end
    end

    context 'additional payload' do
      let(:kwargs) { { payload: { test: true }} }

      it 'allows to pass additional payload' do
        expect(JWT).to receive(:encode).with(hash_including(test: true), 'secret', 'HS256', {})
        subject.call
      end
    end

    context 'additional claims' do
      let(:kwargs) { { claims: { test: true }} }

      it 'has the default claims' do
        expect(JWT).to receive(:encode).with(hash_including(:iss, :iat, :exp), 'secret', 'HS256', {})
        subject.call
      end

      it 'allows to pass additional claims' do
        expect(JWT).to receive(:encode).with(hash_including(test: true), 'secret', 'HS256', {})
        subject.call
      end
    end

    context 'additional header_fields' do
      let(:kwargs) { { header_fields: { test: true }} }

      it 'allows to pass additional header_fields' do
        expect(JWT).to receive(:encode).with(kind_of(Hash), 'secret', 'HS256', { test: true })
        subject.call
      end
    end
  end
end
