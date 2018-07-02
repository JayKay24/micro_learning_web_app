require_relative '../spec_helper'
require_relative '../../app/controllers/user_controller'

RSpec.describe UserController do
  it 'should display "Welcome" in the home page' do
    get '/'

    expect(last_response.body).to include('Welcome to Erudite')
  end
end