require 'rails_helper'

RSpec.describe "Bunruis", type: :request do
  describe "GET /bunruis" do
    it "works! (now write some real specs)" do
      get bunruis_path
      expect(response).to have_http_status(200)
    end
  end
end
