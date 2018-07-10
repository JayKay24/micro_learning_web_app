require_relative './application_controller'
require_relative '../../models/category'
require 'warden'

class CategoryController < ApplicationController
  get '/create_category' do
    redirect '/login' unless current_user
    @current_user = current_user
    haml :create_category
  end

  get '/categories' do
    puts warden_handler.raw_session.inspect
    puts current_user
    redirect '/login' unless current_user
    @current_user = current_user
    @categories = Category.where(user_id: current_user.id)
    haml :categories
  end

  post '/create_category' do
    puts warden_handler.raw_session.inspect
    puts current_user
    redirect '/login' unless current_user
    @current_user = current_user
    puts params
    @category = Category.new(category_name: params[:category],
                             description: params[:category_description],
                             user_id: current_user.id)

    if @category.save
      flash[:success] = 'Category saved successfully.'
    else
      flash[:error] = @category.errors.messages[:category_name][0]
    end

    redirect '/categories'
  end
end