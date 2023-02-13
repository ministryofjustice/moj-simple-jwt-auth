# frozen_string_literal: true

module SimpleJwtAuth
  class Decode
    include Traits::Configurable

    def initialize(token, options = {})
      @token = token
      @options = options
    end

    def call
      JWT.decode(token, nil, true, options) do |_headers, payload|
        issuer = payload['iss']

        config.logger.debug "Decoding JWT token from issuer: #{issuer}"
        secrets.secret_for(issuer)
      end
    end

    private

    attr_reader :token

    def options
      @options.merge(
        required_claims: %w[iss iat exp],
        algorithm: config.algorithm,
        exp_leeway: config.exp_leeway,
        nbf_leeway: config.exp_leeway,
        iss: secrets.issuers,
        verify_iss: true,
        verify_iat: true
      )
    end
  end
end
