# frozen_string_literal: true

require 'jwt'
require 'logger'

require_relative 'simple_jwt_auth/version'
require_relative 'simple_jwt_auth/configuration'
require_relative 'simple_jwt_auth/secrets'
require_relative 'simple_jwt_auth/errors'

require_relative 'simple_jwt_auth/traits/configurable'

require_relative 'simple_jwt_auth/claims'
require_relative 'simple_jwt_auth/encode'
require_relative 'simple_jwt_auth/decode'

# Middleware helpers
require_relative 'simple_jwt_auth/middleware/faraday/jwt' if defined?(Faraday)
require_relative 'simple_jwt_auth/middleware/grape/jwt' if defined?(Grape)
require_relative 'simple_jwt_auth/middleware/grape/authorisation' if defined?(Grape)

module SimpleJwtAuth
end
