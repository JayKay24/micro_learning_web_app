require_relative '../../models/user'
require_relative './application_controller'
require 'bcrypt'

class UserController < ApplicationController
  get '/signup' do
    haml :signup
  end

  get '/login' do
    haml :login
  end

  get '/logout' do
    warden_handler.logout
    flash[:success] = 'Successfully logged out'
    redirect '/'
  end

  post '/signup' do
    @user = User.new(first_name: params['first_name'],
                     last_name: params['last_name'],
                     email: params['email'],
                     password: params['password'])
    @user.save
    warden_handler.authenticate!
    if warden_handler.authenticated?
      flash[:success] = 'You were successfully logged in.'
      # @current_user = current_user
      redirect '/categories'
    else
      flash[:error] = 'There was a problem logging you in.'
      redirect '/'
    end
  end

  post '/login' do
    warden_handler.authenticate!
    if warden_handler.authenticated?
      flash[:success] = 'Successfully logged in!'
      # @current_user = current_user
      redirect '/categories'
    else
      flash[:error] = 'Invalid login credentials. Please register with the application first.'
      redirect '/register'
    end
  end
end
