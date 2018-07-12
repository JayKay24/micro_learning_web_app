require_relative '../../models/category'

class SettingController < ApplicationController
  get '/settings' do
    redirect '/login' unless current_user
    @current_user = current_user

    @categories = @current_user.categories
    haml :'shared/settings'
  end

  post '/settings' do
    redirect '/login' unless current_user
    @current_user = current_user
    @current_user.categories.each do |category|
      category.active = false
      category.save
    end
    selected_category = @current_user.categories.find_by(
      category_name: params[:category]
    )
    selected_category.active = true
    selected_category.time_interval = params[:time_interval]
    if selected_category.save
      flash[:success] = 'Settings saved successfully'
      redirect '/categories'
    else
      flash[:error] = 'There was an error saving your settings'
      redirect 'shared/settings'
    end
  end
end