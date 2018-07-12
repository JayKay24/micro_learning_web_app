require_relative '../spec_helper'
require_relative '../../app/controllers/category_controller'

RSpec.describe CategoryController do
  def app
    @app ||= CategoryController
  end

  describe "GET '/categories'" do
    it 'should redirect to login if user is not logged in' do
      get '/categories'

      expect(last_response.redirect?).to be true
      follow_redirect!

      expect(last_request.path).to eq('/login')
    end
  end
end