# frozen_string_literal: true

module SimpleJwtAuth
  module Middleware
    module Grape
      class Jwt < ::Grape::Middleware::Auth::Base
        ENV_AUTH_KEY = 'HTTP_AUTHORIZATION'
        ENV_PAYLOAD_KEY = 'grape_jwt.payload'

        # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
        def call(env)
          return app.call(env) if test_env?(env)

          token = env.fetch(ENV_AUTH_KEY, '').split.last

          begin
            payload, _header = SimpleJwtAuth::Decode.new(token).call
            env[ENV_PAYLOAD_KEY] = payload

            logger.debug "Authorized request, JWT payload: #{payload}"

            app.call(env)
          rescue SimpleJwtAuth::Errors::Forbidden => e
            logger.warn "JWT issuer forbidden: #{e.message}"
            rack_response(403, e.message)
          rescue SimpleJwtAuth::Errors::IssuerError => e
            logger.warn "JWT issuer error: #{e.message}"
            rack_response(400, e.message)
          rescue JWT::DecodeError => e
            logger.warn "Unauthorized request, JWT error: #{e.message}"
            rack_response(401, e.message)
          end
        end
        # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

        private

        def test_env?(env)
          env['rack.test'] == true
        end

        def rack_response(http_code, error_msg)
          [http_code, { 'Content-Type' => 'application/json' }, [{ error: error_msg }.to_json]]
        end

        def logger
          SimpleJwtAuth.configuration.logger
        end
      end
    end
  end
end

# :nocov:
Grape::Middleware::Auth::Strategies.add(
  :jwt, SimpleJwtAuth::Middleware::Grape::Jwt, ->(options) { [options] }
)
# :nocov:
