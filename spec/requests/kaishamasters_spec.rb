require 'rails_helper'

RSpec.describe "Kaishamasters", type: :request do
  describe "GET /kaishamasters" do
    it "works! (now write some real specs)" do
      get kaishamasters_path
      expect(response).to have_http_status(200)
    end
  end
end
