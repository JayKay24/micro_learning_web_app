require 'rack'
require 'sinatra'
require 'sinatra/flash'
require 'warden'
require_relative '../../models/user'

class FailureApp
  def call(env)
    uri = env['REQUEST_URI']
    puts "failure #{env['REQUEST_METHOD']}#{uri}"
  end
end

class ApplicationController < Sinatra::Base
  %w[/category /category/* /history /link/* /settings].each do |path|
    before path do
      check_if_logged_in
    end
  end
  # Set folder for templates to ../views, but make the path absolute
  set views: File.expand_path('../views', __dir__)
  set public: File.expand_path('../../public', __dir__)

  register Sinatra::Flash
  use Rack::Session::Cookie, secret: ENV['RACK_SECRET']
  use Rack::MethodOverride

  use Warden::Manager do |config|
    config.default_strategies :password
    config.failure_app = FailureApp.new
  end

  # Session setup
  Warden::Manager.serialize_into_session do |user|
    user.id
  end

  Warden::Manager.serialize_from_session do |id|
    User.find(id)
  end

  # Warden strategies
  Warden::Strategies.add(:password) do
    def valid?
      params['email'] && params['password']
    end

    def authenticate!
      user = User.authenticate(params['email'], params['password'])
      success!(user) if user
      success!(User.new) unless user
    end
  end

  Warden::Manager.before_failure do |env, opts|
    env['REQUEST_METHOD'] = 'POST'
  end

  def warden_handler
    env['warden']
  end

  def check_authentication
    redirect '/login' unless warden_handler.authenticated?
  end

  def current_user
    warden_handler.user
  end

  get '/' do
    haml :'shared/home'
  end

  def check_if_logged_in
    redirect '/login' unless current_user
    @current_user = current_user
  end
end
