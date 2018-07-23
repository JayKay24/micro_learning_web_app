require_relative '../spec_helper'
require_relative '../../app/controllers/user_controller'
require_relative '../../models/user'
require 'database_cleaner'
require 'rake'
require 'warden'
require_relative '../helpers/controller_helpers'

RSpec.describe UserController do
  include Helpers::Controllers

  DatabaseCleaner.strategy = :truncation

  before :each do
    @user = create(:user)
  end

  after :each do
    Warden.test_reset!
    DatabaseCleaner.clean
  end

  describe "GET '/signup'" do
    it 'should display "Sign Up" in the sign up page' do
      get '/signup'

      expect(last_response).to be_ok
      expect(last_response.body).to include('Sign Up')
    end
  end

  describe "GET '/login'" do
    it 'should display "Log In" in the log in page' do
      get '/login'

      expect(last_response).to be_ok
      expect(last_response.body).to include('Log In')
    end
  end

  describe "POST '/login'" do
    context 'with valid login credentials' do
      it 'should login a registered user into the application' do

        post '/login', email: @user.email, password: 'Qwertyuiop123#'

        expect_redirection_to '/categories'
      end

      it 'should log out a registered user from the application' do
        get '/logout'

        expect_redirection_to '/'
        expect(last_response.body).to include('Successfully logged out')
      end
    end

    context 'with invalid login credentials' do
      it 'should redirect the user to the signup page' do

        post '/login', email: 'kal-el@example.com', password: 'NoQwertyuiop123#'

        expect_redirection_to '/signup'
      end
    end
  end

  describe "POST '/signup'" do
    context 'with valid registration information' do
      it 'should register a user into the application' do

        post '/signup',
             first_name: 'James',
             last_name: 'Njuguna',
             email: 'jameskinyua590@gmail.com',
             password: 'Qwertyuiop123#'

        expect_redirection_to '/categories'
      end
    end

    context 'with invalid registration information' do
      it 'should not register a user into the application' do

        post '/signup',
             first_name: nil,
             last_name: nil,
             email: nil,
             password: nil

        expect_redirection_to '/signup'
      end
    end
  end
end
