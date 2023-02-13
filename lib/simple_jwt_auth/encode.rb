# frozen_string_literal: true

module SimpleJwtAuth
  class Encode
    include Traits::Configurable

    def initialize(payload: {}, claims: {}, header_fields: {})
      @payload = payload
      @claims = claims
      @header_fields = header_fields
    end

    def call
      jwt_payload = payload.merge(claims)
      issuer = jwt_payload.fetch(:iss)

      config.logger.debug "Encoding JWT payload: #{jwt_payload}"

      JWT.encode(
        jwt_payload,
        secrets.secret_for(issuer),
        config.algorithm,
        header_fields
      )
    end

    private

    attr_reader :payload, :header_fields

    def claims
      Claims.new.merge(@claims)
    end
  end
end
