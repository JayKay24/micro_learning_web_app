require_relative '../spec_helper'
require_relative '../../app/controllers/application_controller'
require_relative '../helpers/controller_helpers'

RSpec.describe ApplicationController do
  include Helpers::Controllers

  describe "GET '/'" do
    it 'should display welcome in the home page' do
      get '/'

      expect(last_response).to be_ok
      expect(last_response.body).to include('Welcome to Erudite')
    end
  end
end
