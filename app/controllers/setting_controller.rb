require_relative '../../models/category'
require_relative '../../app/controllers/user_controller'

class SettingController < ApplicationController
  get '/settings' do
    @categories = @current_user.categories
    haml :'shared/settings'
  end

  post '/settings' do
    @current_user.categories.each do |category|
      category.active = false
      category.save
    end

    selected_category = @current_user.categories.find_by(
      category_name: params[:category]
    )
    if selected_category
      selected_category.active = true
      selected_category.time_interval = params[:time_interval]
      if selected_category.save
        flash[:success] = 'Settings saved successfully'
        redirect '/categories'
      else
        flash[:error] = 'There was an error saving your settings'
        redirect '/settings'
      end
    else
      flash[:error] = "You haven't activated a category"
      redirect '/settings'
    end
  end
end