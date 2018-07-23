require_relative '../spec_helper'
require_relative '../../app/controllers/link_controller'
require 'database_cleaner'
require 'warden'
require_relative '../helpers/controller_helpers'


RSpec.describe LinkController do
  include Helpers::Controllers

  DatabaseCleaner.strategy = :truncation

  let(:user) { create(:user) }

  after :each do
    Warden.test_reset!
    DatabaseCleaner.clean
  end

  describe "GET '/history'" do
    it 'should redirect to login if the user is not logged in' do
      get '/history'

      expect_redirection_to '/login'
    end
  end

  describe "GET '/category_links/:category_id'" do
    context 'authenticated user' do
      it 'should display category links of the selected category' do

        login_and_create_category

        get '/category_links/1'

        expect(last_response.body).to include('Superman')
        expect(last_request.path).to eq('/category_links/1')
      end
    end

    context 'unauthenticated user' do
      it 'should redirect an unauthenticated user back to login' do
        get '/category_links/1'

        expect_redirection_to '/login'
      end
    end
  end

  describe "GET '/category_link/:category_id'" do
      context 'authenticated user' do
        it 'should display a link of the selected category' do

          login_and_create_category

          get '/category_link/1'

          expect(last_request.path).to eq('/category_link/1')
        end
      end

      context 'unauthenticated user' do
        it 'should redirect an unauthenticated user back to login' do
          get '/category_links/1'

          expect_redirection_to '/login'
        end
      end
    end

  describe "POST '/category_links/:category_id'" do
    context 'already logged in user' do
      it 'should fetch all links pertaining to the category ' do
        login_and_create_category

        get '/category_links/1'

        expect(last_request.path).to eq('/category_links/1')
      end
    end
  end

  def login_and_create_category
    login_as user

    user.categories.create(
      category_name: 'Superman',
      description: 'All things Superman'
    )
  end
end