require_relative '../spec_helper'
require_relative '../../app/controllers/link_controller'
require 'database_cleaner'
require 'warden'
require_relative '../helpers/controller_helpers'
require_relative '../../models/link.rb'


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

  describe "GET '/category/:category_id/link'" do
    context 'authenticated user' do
      it 'should display category links of the selected category' do
        login_and_create_category

        get '/category/1/links'

        expect(last_response.body).to include('Superman')
        expect(last_request.path).to eq('/category/1/links')
      end
    end

    context 'unauthenticated user' do
      it 'should redirect an unauthenticated user back to login' do
        get '/category/1/links'

        expect_redirection_to '/login'
      end
    end
  end

  describe "GET '/category/:category_id/link'" do
    context 'authenticated user' do
      it 'should display a link of the selected category' do
        login_and_create_category

        get '/category/1/link'

        expect(last_request.path).to eq('/category/1/link')
        expect(Link.count).to eq(1)
      end
    end

    context 'unauthenticated user' do
      it 'should redirect an unauthenticated user back to login' do
        get '/category/1/link'

        expect_redirection_to '/login'
      end
    end
  end

  it "should display 'Today's Link'" do
    login_as user

    get '/link/today' do
      expect(last_response.body).to include("Today's Link")
    end
  end

  it "should show today's link" do
    category = login_and_create_category
    category.active = true
    category.save

    link = category.links.create(
      link_name: 'Superman - Wikipedia',
      link: 'https://en.wikipedia.org/wiki/Superman',
      snippet: 'Superman is a fictional superhero.',
      scheduled: true
    )

    get '/link/view'

    expect_redirection_to '/link/today'
    expect(last_response.body).to include('Superman')
    expect(last_response.body).to include('https://en.wikipedia.org/wiki/Superman')
  end

  def login_and_create_category
    login_as user

    user.categories.create(
      category_name: 'Superman',
      description: 'All things Superman'
    )
  end
end
