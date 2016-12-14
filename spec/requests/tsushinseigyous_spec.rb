require 'rails_helper'

RSpec.describe "Tsushinseigyous", type: :request do
  describe "GET /tsushinseigyous" do
    it "works! (now write some real specs)" do
      get tsushinseigyous_path
      expect(response).to have_http_status(200)
    end
  end
end
