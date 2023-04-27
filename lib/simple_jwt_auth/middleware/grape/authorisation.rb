# frozen_string_literal: true

module SimpleJwtAuth
  module Middleware
    module Grape
      class Authorisation < ::Grape::Middleware::Base
        def before
          return if test_env? || consumer_authorised?

          raise SimpleJwtAuth::Errors::Forbidden,
                "access to endpoint forbidden for issuer `#{current_issuer}`"
        end

        private

        def test_env?
          env['rack.test'] == true
        end

        def consumer_authorised?
          route_authorised_consumers.include?(current_issuer) ||
            route_authorised_consumers.include?('*')
        end

        def route_authorised_consumers
          context.route.settings.fetch(:authorised_consumers, [])
        end

        def current_issuer
          env.fetch(Jwt::ENV_PAYLOAD_KEY, {})['iss']
        end
      end
    end
  end
end
