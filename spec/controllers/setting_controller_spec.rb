require_relative '../spec_helper'
require_relative '../../app/controllers/setting_controller'

RSpec.describe SettingController do
  def app
    @app ||= SettingController
  end

  describe "GET '/settings'" do
    it 'should redirect to login if the user is not logged in' do
      get '/settings'

      expect(last_response.redirect?).to be true
      follow_redirect!
      expect(last_request.path).to eq('/login')
    end
  end
end