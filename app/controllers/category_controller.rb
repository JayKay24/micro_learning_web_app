require_relative './application_controller'
require_relative '../../models/category'
require 'warden'

class CategoryController < ApplicationController
  get '/category/new' do
    check_if_logged_in

    haml :'category/create_category'
  end

  get '/categories' do
    check_if_logged_in

    @categories = @current_user.categories
    haml :'category/categories'
  end

  post '/category' do
    check_if_logged_in

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