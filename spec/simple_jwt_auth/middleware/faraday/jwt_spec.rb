require 'rspec'
require 'faraday'
require 'simple_jwt_auth/middleware/faraday/jwt'

RSpec.describe SimpleJwtAuth::Middleware::Faraday::Jwt do
  subject { described_class.new(app, **kwargs) }

  let(:app) { double('app') }
  let(:kwargs) { {} }

  describe '#on_request' do
    let(:env) { double(request_headers: {}) }

    before do
      allow(
        SimpleJwtAuth::Encode
      ).to receive(:new).and_return(double(call: 'xyz123'))
    end

    it 'adds the authorization request header' do
      subject.on_request(env)

      expect(env.request_headers['Authorization']).to eq('Bearer xyz123')
    end

    context 'encoder additional arguments' do
      let(:kwargs) { { payload: { test: true }} }

      it 'propagates the arguments' do
        expect(
          SimpleJwtAuth::Encode
        ).to receive(:new).with(payload: { test: true })

        subject.on_request(env)
      end
    end
  end
end
