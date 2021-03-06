require_relative '../spec_helper'
require_relative '../../app/controllers/setting_controller'
require_relative '../helpers/controller_helpers'
require_relative '../../models/category.rb'

RSpec.describe SettingController do
  include Helpers::Controllers

  DatabaseCleaner.strategy = :truncation

  let(:user) { create(:user) }

  after :each do
    Warden.test_reset!
    DatabaseCleaner.clean
  end

  context 'with invalid login information' do
    it 'should redirect to login if the user is not logged in' do
      get '/settings'

      expect_redirection_to '/login'
    end
  end

  context 'with valid login information' do
    it 'should take the user to the settings route' do
      login_as user

      get '/settings'

      expect(last_request.path).to eq('/settings')
      expect(last_response.body).to include('Settings')
    end

    it 'should activate the category if the user is logged in' do
      login_as user

      category = user.categories.create(
        category_name: 'Superman',
        description: 'A world of heroes'
      )

      post '/settings', category: category.category_name, time_interval: '10'

      expect(category.save).to be true
      expect_redirection_to '/category'
      expect(Category.first.active).to be true
    end
  end
end
