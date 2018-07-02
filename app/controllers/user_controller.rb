class UserController < ApplicationController
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