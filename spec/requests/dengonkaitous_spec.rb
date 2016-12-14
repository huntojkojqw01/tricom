require 'rails_helper'

RSpec.describe "Dengonkaitous", type: :request do
  describe "GET /dengonkaitous" do
    it "works! (now write some real specs)" do
      get dengonkaitous_path
      expect(response).to have_http_status(200)
    end
  end
end
