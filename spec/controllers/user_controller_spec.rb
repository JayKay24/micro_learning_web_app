require_relative '../spec_helper'
require_relative '../../app/controllers/user_controller'

RSpec.describe UserController do
  def app
    @app ||= UserController
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
end