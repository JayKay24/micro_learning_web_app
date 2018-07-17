module Helpers
  module Controllers
    def app
      @app ||= described_class
    end

    def expect_redirection_to(route)
      expect(last_response.redirect?).to be true
      follow_redirect!
      expect(last_request.path).to eq(route)
    end
  end
end