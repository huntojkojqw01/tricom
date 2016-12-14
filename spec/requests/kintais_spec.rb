require 'rails_helper'

RSpec.describe "Kintais", type: :request do
  describe "GET /kintais" do
    it "works! (now write some real specs)" do
      get kintais_path
      expect(response).to have_http_status(200)
    end
  end
end
