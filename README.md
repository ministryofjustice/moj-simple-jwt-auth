# Simple JWT Auth ruby gem

A basic wrapper around [ruby-jwt gem](https://github.com/jwt/ruby-jwt) that includes two middlewares, one for Faraday 
to facilitate generating the JWT token and sending it in the Authorization Bearer header, and another for Grape to facilitate 
the verification of this token and handling of the payload in the rack env.

## Installation

```ruby
# directly from Github
gem 'moj-simple-jwt-auth', github: 'ministryofjustice/moj-simple-jwt-auth'

# or from RubyGems
gem 'moj-simple-jwt-auth', '0.0.1'
```

You can lock it to a specific version, branch or sha if you want too.

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

### Example of token

This is a valid format token (might become invalid due to expiration at some point):

`eyJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE2ODI1OTMwMzAsImV4cCI6MTY5ODQwNDU1NSwiaXNzIjoiY3JpbWUtYXBwbHkifQ.x2UE5VnwN5mf8elByPBnjiNChvsySqDjiLht6eN3ZPY`

It has 3 parts, separated by dots, base64-encoded:

1. Header (`eyJhbGciOiJIUzI1NiJ9`), containing the algorithm used. No other details are needed.
    ```json
    {
      "alg": "HS256"
    }
    ```

2. Payload (`eyJpYXQiOjE2ODI1OTMwMzAsImV4cCI6MTY5ODQwNDU1NSwiaXNzIjoiY3JpbWUtYXBwbHkifQ`), with some mandatory details.
    ```json
    {
      "iat": 1682593030,
      "exp": 1698404555,
      "iss": "crime-apply"
    }
    ```
   *iat* is the issued at seconds since epoch, *exp* is the expire at seconds since epoch, and finally *iss* is the issuer identifier or the name of the consumer to whom this token belongs.

3. Signature (`x2UE5VnwN5mf8elByPBnjiNChvsySqDjiLht6eN3ZPY`)

   To create the signature part you have to take the encoded header, the encoded payload, a secret, the algorithm specified in the header, and sign that.

The token must be included in each request, in an Authorization header (bearer).

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bundle exec rake` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

This gem uses rubocop and simplecov (at 100% coverage).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ministryofjustice/moj-simple-jwt-auth.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
