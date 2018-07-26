require 'rack/test'
require 'rspec'
require 'coveralls'
require 'simplecov'
require 'simplecov-console'
require_relative './helpers/factory_bot'
require 'warden'

require_relative '../services/bing_service'
require_relative 'mocks/bing_mock'

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
  config.include Warden::Test::Helpers

  config.before(:each) do
    allow(BingService::BingWebSearchApi).to receive(:links).and_return BingMock.new.links
  end

end