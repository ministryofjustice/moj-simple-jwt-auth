# frozen_string_literal: true

module SimpleJwtAuth
  class Secrets
    def initialize(secrets)
      @secrets = secrets
    end

    # Get all configured issuers
    #
    # @return [Array] list of configured issuers
    #
    def issuers
      secrets.keys
    end

    # Get secret for a specific issuer
    # Used when decoding, to retrieve the secret for an issuer
    #
    # @param issuer [String] The issuer to retrieve their secret
    #
    # @raise [SimpleJwtAuth::Errors::UndefinedIssuer]
    # @raise [SimpleJwtAuth::Errors::UnknownIssuer]
    #
    # @return [String] issuer secret
    #
    def secret_for(issuer)
      raise(
        Errors::UndefinedIssuer, 'issuer has not been configured'
      ) unless issuer

      raise(
        Errors::UnknownIssuer, "issuer `#{issuer}` is not recognized"
      ) unless secrets.key?(issuer)

      secrets.fetch(issuer)
    end

    private

    attr_reader :secrets
  end

  # Get current secrets
  #
  # @return [SimpleJwtAuth::Secrets] current secrets
  #
  def self.secrets
    @secrets ||= Secrets.new(configuration.secrets_config)
  end
end
