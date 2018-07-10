require_relative '../spec_helper'
require_relative '../../app/controllers/user_controller'

RSpec.describe UserController do
  it 'should display "Welcome" in the home page' do
    get '/'

    expect(last_response).to be_ok
    expect(last_response.body).to include('Welcome to Erudite')
  end

  it 'should display "Sign Up" in the sign up page' do
    get '/signup'

    expect(last_response).to be_ok
    expect(last_response.body).to include('Sign Up')
  end

  it 'should display "Log In" in the log in page' do
    get '/login'

    expect(last_response).to be_ok
    expect(last_response.body).to include('Log In')
  end
end