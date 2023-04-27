require 'rspec'
require 'grape'
require 'simple_jwt_auth/middleware/grape/jwt'
require 'simple_jwt_auth/middleware/grape/authorisation'

RSpec.describe SimpleJwtAuth::Middleware::Grape::Authorisation do
  subject { described_class.new(app, options) }

  let(:app) { double('app') }
  let(:options) { nil }

  describe '#call' do
    let(:env) { { 'grape_jwt.payload' => { 'iss' => issuer } } }

    context 'when running in test mode' do
      let(:env) { { 'rack.test' => true } }

      it 'skips the middleware' do
        expect(subject).not_to receive(:consumer_authorised?)
        expect(app).to receive(:call).with(env)

        subject.call(env)
      end
    end

    context 'authorising consumers based on route settings' do
      let(:route_settings) { { authorised_consumers: authorised_consumers } }
      let(:context_double) { double(route: double(settings: route_settings)) }

      before do
        allow_any_instance_of(described_class).to receive(:context).and_return(context_double)
      end

      context 'for a consumer with access to the current route' do
        let(:authorised_consumers) { ['consumer-name'] }
        let(:issuer) { 'consumer-name' }

        it 'pass control to the app' do
          expect(app).to receive(:call).with(env)

          subject.call(env)
        end
      end

      context 'for a consumer with access to a wildcard-authorised route' do
        let(:authorised_consumers) { ['*'] }
        let(:issuer) { 'consumer-name' }

        it 'pass control to the app' do
          expect(app).to receive(:call).with(env)

          subject.call(env)
        end
      end

      context 'for a consumer without access to the current route' do
        let(:authorised_consumers) { ['foobar-consumer'] }
        let(:issuer) { 'consumer-name' }

        it 'raises a forbidden exception' do
          expect(app).not_to receive(:call).with(env)

          expect {
            subject.call(env)
          }.to raise_error(
            SimpleJwtAuth::Errors::Forbidden, "access to endpoint forbidden for issuer `consumer-name`"
          )
        end
      end

      context 'for a route without declared authorised consumers' do
        let(:route_settings) { {} }
        let(:issuer) { 'consumer-name' }

        it 'raises a forbidden exception' do
          expect(app).not_to receive(:call).with(env)

          expect {
            subject.call(env)
          }.to raise_error(
            SimpleJwtAuth::Errors::Forbidden, "access to endpoint forbidden for issuer `consumer-name`"
          )
        end
      end
    end
  end
end
