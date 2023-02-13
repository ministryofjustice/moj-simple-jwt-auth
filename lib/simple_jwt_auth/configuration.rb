# frozen_string_literal: true

module SimpleJwtAuth
  class Configuration
    attr_accessor :logger,
                  :exp_seconds,
                  :exp_leeway,
                  :algorithm,
                  :issuer,
                  :secrets_config

    def initialize
      # Defaults to stdout and level info, can be configured
      @logger = ::Logger.new($stdout)
      @logger.level = ::Logger::INFO

      # https://www.rfc-editor.org/rfc/rfc7519#section-4.1.4
      @exp_seconds = 30

      # Small leeway to account for clock skew (seconds)
      @exp_leeway = 10

      # HMAC SHA-256 hash algorithm
      @algorithm = 'HS256'

      # A map of issuers and corresponding secrets
      @secrets_config = {}
    end
  end

  # Get current configuration
  #
  # @return [SimpleJwtAuth::Configuration] current configuration
  #
  def self.configuration
    @configuration ||= Configuration.new
  end

  # Configure the gem
  #
  # Any attributes listed in +attr_accessor+ can be configured
  #
  # @example
  #   SimpleJwtAuth.configure do |config|
  #     config.issuer = 'MyApp'
  #     config.exp_seconds = 120
  #   end
  #
  def self.configure
    yield configuration
  end
end
