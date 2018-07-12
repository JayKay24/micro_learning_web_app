require 'rack/test'
require 'rspec'
require 'coveralls'
require 'simplecov'
require 'simplecov-console'

Coveralls.wear!

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new(
  [
    SimpleCov::Formatter::Console,
    # For code coverage website
    SimpleCov::Formatter::HTMLFormatter
  ]
)

ENV['RACK_ENV'] = 'test'

RSpec.configure do |config|
  config.include Rack::Test::Methods
end