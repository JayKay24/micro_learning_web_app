require_relative './application_controller'

class UserController < ApplicationController
  get '/' do
    haml :home
  end

  get '/users' do
    @users = User.all
    haml :users
  end

  post '/submit' do
    @user = User.new(params[:user])

    'Sorry, there was an error!' unless @user.save
    redirect '/users' if @user.save
  end
end