require_relative '../spec_helper'
require_relative '../../app/controllers/category_controller'
require 'database_cleaner'
require 'warden'
require_relative '../helpers/controller_helpers'

RSpec.describe CategoryController do
  include Helpers::Controllers

  DatabaseCleaner.strategy = :truncation

  let(:user) { create(:user) }

  after :each do
    Warden.test_reset!
    DatabaseCleaner.clean
  end

  describe "GET '/categories'" do
    it 'should redirect to login if user is not logged in' do
      get '/categories'

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

      expect_redirection_to '/categories'
      expect(user.categories.first.category_name).to eq('Justice League')
    end
  end

  describe "PUT '/category/:category_id'" do
    it 'should delete a category for a logged in user' do
      login_as user

      category = create_category(user)

      put "/category/#{category.id}",
          category: 'Thawne',
          description: 'Reverse flash'

      expect_redirection_to '/categories'
    end
  end

  describe "DELETE '/category/:category_id'" do
    it 'should delete a category for a logged in user' do
      login_as user

      category = create_category(user)

      delete "/category/#{category.id}", category_id: category.id

      expect_redirection_to '/categories'
    end
  end
end