require 'rspec'
require 'grape'
require 'simple_jwt_auth/middleware/grape/jwt'

RSpec.describe SimpleJwtAuth::Middleware::Grape::Jwt do
  subject { described_class.new(app, options) }

  let(:app) { double('app') }
  let(:options) { nil }

  describe '#call' do
    let(:env) { { 'HTTP_AUTHORIZATION' => 'Bearer xyz123' } }
    let(:decoder_double) { double(call: { payload: 'foobar' }) }

    context 'when running in test mode' do
      let(:env) { { 'rack.test' => true } }

      it 'skips the middleware' do
        expect(SimpleJwtAuth::Decode).not_to receive(:new)
        expect(app).to receive(:call).with(env)

        subject.call(env)
      end
    end

    context 'for a valid token' do
      before do
        allow(app).to receive(:call).with(env)

        allow(
          SimpleJwtAuth::Decode
        ).to receive(:new).with('xyz123').and_return(decoder_double)
      end

      it 'stores the payload in the env' do
        expect(env).to receive(:[]=).with('grape_jwt.payload', { payload: 'foobar' })
        subject.call(env)
      end

      it 'pass control to the app' do
        expect(app).to receive(:call).with(env)
        subject.call(env)
      end
    end

    context 'for an invalid token' do
      let(:response) do
        [
          401,
          { 'Content-Type' => 'application/json' },
          [{ status: 401, error: 'Not enough or too many segments' }.to_json]
        ]
      end

      it 'returns a rack error response' do
        expect(subject.call(env)).to eq(response)
      end
    end
  end
end
