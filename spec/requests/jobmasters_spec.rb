require 'rails_helper'

RSpec.describe "Jobmasters", type: :request do
  describe "GET /jobmasters" do
    it "works! (now write some real specs)" do
      get jobmasters_path
      expect(response).to have_http_status(200)
    end
  end
end
