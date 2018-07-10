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
  # Set folder for templates to ../views, but make the path absolute
  set views: File.expand_path('../views', __dir__)

  configure(:development, :test) { set :session_secret, ENV['SHOTGUN_SECRET'] }
  enable :sessions
  register Sinatra::Flash
  # use Rack::Session::Cookie, secret: ENV['RACK_SECRET']
  use Rack::Session::Cookie

  use Warden::Manager do |config|
    config.default_strategies :password
    config.failure_app = FailureApp.new
  end

  # Session setup
  Warden::Manager.serialize_into_session do |user|
    puts '[INFO] serialize into session'
    user.id
  end

  Warden::Manager.serialize_from_session do |id|
    puts '[INFO] serialize from session'
    User.find(id)
  end

  # Warden strategies
  Warden::Strategies.add(:password) do
    def valid?
      puts '[INFO] password strategy valid?'
      params['email'] && params['password']
    end

    def authenticate!
      puts '[INFO] password strategy authenticate'
      user = User.authenticate(params['email'], params['password'])

      if user
        success!(user)
        # @@current_user = current_user
        # @current_user = env['warden'].user
      else
        fail!('The email you entered does not exist')
      end
      # success!(user) unless user.nil?
      # fail!('The email you entered does not exist') if user.nil?
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
    haml :home
  end
end