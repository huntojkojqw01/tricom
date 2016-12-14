require 'rails_helper'

RSpec.describe "Kairanyokenmsts", type: :request do
  describe "GET /kairanyokenmsts" do
    it "works! (now write some real specs)" do
      get kairanyokenmsts_path
      expect(response).to have_http_status(200)
    end
  end
end
