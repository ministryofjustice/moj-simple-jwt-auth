# frozen_string_literal: true

module SimpleJwtAuth
  module Middleware
    module Faraday
      class Jwt < ::Faraday::Middleware
        AUTH_HEADER = 'Authorization'
        AUTH_SCHEME = 'Bearer'

        def initialize(app = nil, **kwargs)
          @kwargs = kwargs
          super(app)
        end

        def on_request(env)
          env.request_headers[AUTH_HEADER] = [AUTH_SCHEME, jwt_token].join(' ')
        end

        private

        def jwt_token
          SimpleJwtAuth::Encode.new(**@kwargs).call
        end
      end
    end
  end
end

# :nocov:
Faraday::Request.register_middleware(
  jwt: SimpleJwtAuth::Middleware::Faraday::Jwt
)
# :nocov:
