require_relative './application_controller'
require_relative '../../models/category'
require 'warden'

class CategoryController < ApplicationController
  get '/create_category' do
    redirect '/login' unless current_user
    @current_user = current_user
    haml :'category/create_category'
  end

  get '/categories' do
    redirect '/login' unless current_user
    @current_user = current_user
    @categories = @current_user.categories
    haml :'category/categories'
  end

  post '/create_category' do
    redirect '/login' unless current_user
    @current_user = current_user
    @category = @current_user.categories.create(category_name: params[:category],
                                                description: params[:category_description])

    if @category.save
      flash[:success] = 'Category saved successfully.'
    else
      flash[:error] = @category.errors.messages[:category_name][0]
    end

    redirect '/categories'
  end
end