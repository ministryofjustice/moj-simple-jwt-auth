# frozen_string_literal: true

module SimpleJwtAuth
  class Claims
    include Traits::Configurable

    def initialize
      @now = Time.now.to_i
    end

    def merge(other_hash)
      to_h.merge(other_hash)
    end

    def to_h
      {
        iat: @now,
        exp: @now + config.exp_seconds,
        iss: config.issuer
      }
    end
  end
end
