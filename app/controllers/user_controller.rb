require_relative '../../models/user'
require_relative './application_controller'
require 'bcrypt'

class UserController < ApplicationController
  get '/signup' do
    haml :'user_management/signup'
  end

  get '/login' do
    haml :'user_management/login'
  end

  get '/logout' do
    warden_handler.logout
    flash[:success] = 'Successfully logged out'
    redirect '/'
  end

  post '/signup' do
    begin
      @user = User.create(first_name: params[:first_name],
                       last_name: params[:last_name],
                       email: params[:email],
                       password: params[:password])
      warden_handler.authenticate!
      current_user = warden_handler.user
      if current_user
        flash[:success] = 'You were successfully logged in.'
        redirect '/category'
      else
        flash[:error] = 'There was a problem logging you in.'
        redirect '/'
      end
    rescue PasswordNotValidException
      flash[:error] = 'Password must contain at least a lowercase letter, an uppercase, a digit, a special char and 8+ chars'
      redirect '/signup'
    end
  end

  post '/login' do
    warden_handler.authenticate!
    if current_user.first_name.nil?
      flash[:error] = 'Invalid login credentials. Please register with the application first.'
      redirect '/signup'
    else
      flash[:success] = 'Successfully logged in'
      redirect '/category' if warden_handler.user.first_name
    end
  end
end
