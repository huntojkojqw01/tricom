require 'rails_helper'

RSpec.describe "Shozais", type: :request do
  describe "GET /shozais" do
    it "works! (now write some real specs)" do
      get shozais_path
      expect(response).to have_http_status(200)
    end
  end
end
