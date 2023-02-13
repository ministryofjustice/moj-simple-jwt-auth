# frozen_string_literal: true

module SimpleJwtAuth
  module Middleware
    module Grape
      class Jwt < ::Grape::Middleware::Auth::Base
        ENV_AUTH_KEY = 'HTTP_AUTHORIZATION'
        ENV_PAYLOAD_KEY = 'grape_jwt.payload'

        def call(env)
          token = env.fetch(ENV_AUTH_KEY, '').split.last

          begin
            payload, _header = SimpleJwtAuth::Decode.new(token).call
            env[ENV_PAYLOAD_KEY] = payload

            logger.debug "Authorized request, JWT payload: #{payload}"

            app.call(env)
          rescue JWT::DecodeError => e
            logger.warn "Unauthorized request, JWT error: #{e.message}"

            [401, { 'Content-Type' => 'application/json' }, [{ status: 401, error: e.message }.to_json]]
          end
        end

        private

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
