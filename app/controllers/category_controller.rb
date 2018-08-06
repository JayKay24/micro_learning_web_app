require_relative './application_controller'
require_relative '../../models/category'
require 'warden'

class CategoryController < ApplicationController
  get '/category/new' do
    haml :'category/create_category'
  end

  get '/category' do
    @categories = @current_user.categories
    haml :'category/categories'
  end

  get '/category/:category_id' do
    @category = @current_user.categories.find(params[:category_id])

    haml :'/category/edit_category'
  end

  post '/category' do
    @category = @current_user.categories.create(
      category_name: params[:category],
      description: params[:category_description]
    )

    if @category.save
      flash[:success] = 'Category saved successfully.'
    else
      flash[:error] = @category.errors.messages[:category_name][0]
    end

    redirect '/category'
  end

  put '/category/:category_id' do
    category = @current_user.categories.find(params[:category_id])
    category.update(category_name: params[:category],
                    description: params[:category_description])

    if category.saved_changes.empty? == false
      flash[:success] = 'Successfully edited the category'
    end
    redirect '/category'
  end

  delete '/category/:category_id' do
    category = @current_user.categories.find(params[:category_id])

    category.destroy
    flash[:success] = 'Successfully deleted category'
    redirect '/category'
  end
end