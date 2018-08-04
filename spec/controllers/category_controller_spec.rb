require_relative '../spec_helper'
require_relative '../../app/controllers/category_controller'
require 'database_cleaner'
require 'warden'
require_relative '../helpers/controller_helpers'
require_relative '../../models/category.rb'

RSpec.describe CategoryController do
  include Helpers::Controllers

  DatabaseCleaner.strategy = :truncation

  let(:user) { create(:user) }

  after :each do
    Warden.test_reset!
    DatabaseCleaner.clean
  end

  describe "GET '/category'" do
    it 'should redirect to login if user is not logged in' do
      get '/category'

      expect_redirection_to '/login'
    end
  end

  describe "GET '/category/:category_id'" do
    it 'should fetch a category for a logged in user' do
      login_as user

      category = create_category(user)

      get "/category/#{category.id}"

      expect(last_response.body).to include(category.category_name)
    end
  end

  describe "POST '/category'" do
    it 'should create a category for a logged in user' do
      login_as user

      post '/category',
           category: 'Justice League',
           category_description: 'All things Justice League'

      expect_redirection_to '/category'
      expect(user.categories.first.category_name).to eq('Justice League')
    end
  end

  describe "PUT '/category/:category_id'" do
    it 'should edit a category for a logged in user' do
      login_as user

      category = create_category(user)

      put "/category/#{category.id}",
          category: 'Thawne',
          category_description: 'Reverse flash'

      expect_redirection_to '/category'
      expect(last_response.body).to include('Successfully edited the category')
      expect(user.categories.first.category_name).to eq('Thawne')
      expect(user.categories.first.description).to eq('Reverse flash')
    end
  end

  describe "DELETE '/category/:category_id'" do
    it 'should delete a category for a logged in user' do
      login_as user

      category = create_category(user)
      delete "/category/#{category.id}"

      expect_redirection_to '/category'
      expect(Category.count).to eq(0)
    end
  end
end