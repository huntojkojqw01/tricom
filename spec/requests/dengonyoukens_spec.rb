require 'rails_helper'

RSpec.describe "Dengonyoukens", type: :request do
  describe "GET /dengonyoukens" do
    it "works! (now write some real specs)" do
      get dengonyoukens_path
      expect(response).to have_http_status(302)
    end
  end
end
