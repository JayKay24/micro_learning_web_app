require_relative '../../models/user'
require_relative './application_controller'
require 'warden'
require 'bcrypt'

class FailureApp
  def call(env)
    uri = env['REQUEST_URI']
    puts "failure #{env['REQUEST_METHOD']}#{uri}"
  end
end

class UserController < ApplicationController
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

      user.nil? ? fail!('The email you entered does not exist') : success!(user)
    end
  end

  get '/' do
    haml :home
  end

  get '/signup' do
    haml :signup
  end

  get '/login' do
    haml :login
  end

  get '/welcome' do
    redirect '/login' unless env['warden'].user
    @current_user = env['warden'].user
    haml :welcome
  end

  post '/signup' do
    @user = User.new(first_name: params['first_name'],
                     last_name: params['last_name'],
                     email: params['email'],
                     password: params['password'])
    @user.save
    env['warden'].authenticate

    flash[:success] = env['warden'].message

    redirect '/welcome'
  end

  post '/login' do
    if env['warden'].authenticate
      flash[:success] = 'Successfully logged in!'
      redirect '/welcome'
    else
      flash[:error] = 'Invalid login credentials'
      redirect '/login'
    end
  end

  get '/logout' do
    env['warden'].logout
    flash[:success] = 'Successfully logged out'
    redirect '/'
  end
end
