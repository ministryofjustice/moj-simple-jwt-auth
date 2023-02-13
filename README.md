# Simple JWT Auth ruby gem

A basic wrapper around [ruby-jwt gem](https://github.com/jwt/ruby-jwt) that includes two middlewares, one for Faraday 
to facilitate generating the JWT token and sending it in the Authorization Bearer header, and another for Grape to facilitate 
the verification of this token and handling of the payload in the rack env.

## Installation

For now this gem is not being published to rubygems as it is under heavy development so to use it just add
the following to your Gemfile:

```ruby
gem 'simple-jwt-auth', github: 'ministryofjustice/simple-jwt-auth'
```

You can lock it to a specific branch or sha if you want too.

## Usage

You need to configure the gem before you can use it. You can do this, for example with an initializer:

```ruby
require 'simple_jwt_auth'

SimpleJwtAuth.configure do |config|
  config.logger.level = Logger::DEBUG # default level is `info`
  config.exp_seconds = 120 # default is 30 seconds
  config.issuer = 'MyAppName' # only needed for consumers
  config.secrets_config = { 'MyAppName' => 'qwerty' }
end
````

For the **consumer** side, you usually only need to configure the `secrets_config` with one key (your issuer name) and one secret.  
For the **producer** side (the API service for instance) you will need to configure a map of all allowed issuers with their corresponding secrets. 

There are several options you can configure, like expiration, leeway, logging, and more. Please refer to the [Configuration class](lib/simple_jwt_auth/configuration.rb) for more details.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bundle exec rake` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

This gem uses rubocop and simplecov (at 100% coverage).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ministryofjustice/simple-jwt-auth.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
