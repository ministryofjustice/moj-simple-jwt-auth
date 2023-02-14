# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'simple_jwt_auth/version'

Gem::Specification.new do |spec|
  spec.name     = 'moj-simple-jwt-auth'
  spec.version  = SimpleJwtAuth::VERSION

  spec.authors  = ['Jesus Laiz']
  spec.email    = ['zheileman@users.noreply.github.com']

  spec.summary  = 'Simple JWT Auth ruby gem with middleware for Faraday and Grape.'
  spec.homepage = 'https://github.com/ministryofjustice/moj-simple-jwt-auth'
  spec.license  = 'MIT'

  spec.metadata = {
    'rubygems_mfa_required' => 'true'
  }

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end

  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
  spec.required_ruby_version = '>= 3.0.0'

  spec.add_dependency 'json'
  spec.add_dependency 'jwt'
end
