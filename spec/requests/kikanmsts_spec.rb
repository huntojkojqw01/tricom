require 'rails_helper'

RSpec.describe "Kikanmsts", type: :request do
  describe "GET /kikanmsts" do
    it "works! (now write some real specs)" do
      get kikanmsts_path
      expect(response).to have_http_status(200)
    end
  end
end
