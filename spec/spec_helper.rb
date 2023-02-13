# frozen_string_literal: true

require 'bundler/setup'
require 'simplecov'

SimpleCov.minimum_coverage 100
SimpleCov.start

require_relative '../lib/simple_jwt_auth'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before(:each) do
    # Make sure we always end up with a default configuration
    SimpleJwtAuth.instance_variable_set(:@configuration, nil)

    # And disable log traces when running tests
    allow(
      SimpleJwtAuth.configuration.logger
    ).to receive_messages(debug: true, warn: true, info: true)
  end
end
