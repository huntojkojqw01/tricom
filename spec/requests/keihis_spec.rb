require 'rails_helper'

RSpec.describe "Keihis", type: :request do
  describe "GET /keihis" do
    it "works! (now write some real specs)" do
      get keihis_path
      expect(response).to have_http_status(200)
    end
  end
end
