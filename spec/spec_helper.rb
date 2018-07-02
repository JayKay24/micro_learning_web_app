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

module RSpecMixin
  include Rack::Test::Methods
  def app
    UserController
  end
end

RSpec.configure { |config| config.include RSpecMixin }