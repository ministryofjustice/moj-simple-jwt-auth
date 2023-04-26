require 'rspec'
require 'grape'
require 'simple_jwt_auth/middleware/grape/jwt'

RSpec.describe SimpleJwtAuth::Middleware::Grape::Jwt do
  subject { described_class.new(app, options) }

  let(:app) { double('app') }
  let(:options) { nil }

  let(:token) { 'xyz123' }

  describe '#call' do
    let(:env) { { 'HTTP_AUTHORIZATION' => "Bearer #{token}" } }
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

    context 'for an unknown issuer' do
      let(:token) { 'eyJhbGciOiJIUzI1NiJ9.eyJpYXQiOiIxNjgyNTA1NDk3IiwiZXhwIjoiMTY4MjUwNjEwNiIsImlzcyI6ImZvb2Jhci1pc3N1ZXIifQ.0gyP7qXrTRCUMi7TgsV1CbIbXTfALRT5y1Zf3WTup8Y' }

      let(:response) do
        [
          400,
          { 'Content-Type' => 'application/json' },
          [{ status: 400, error: 'issuer `foobar-issuer` is not recognized' }.to_json]
        ]
      end

      it 'returns a rack error response' do
        expect(subject.call(env)).to eq(response)
      end
    end

    context 'for an undefined issuer' do
      let(:token) { 'eyJhbGciOiJIUzI1NiJ9.eyJpYXQiOiIxNjgyNTA1NDk3IiwiZXhwIjoiMTY4MjUwNjEwNiJ9.7WGH6fcyO512eN6fupRiSHh-lVkH7hpEN6wbDYHvEbc' }

      let(:response) do
        [
          400,
          { 'Content-Type' => 'application/json' },
          [{ status: 400, error: 'issuer has not been configured' }.to_json]
        ]
      end

      it 'returns a rack error response' do
        expect(subject.call(env)).to eq(response)
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
