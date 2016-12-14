require 'rails_helper'

RSpec.describe "Kairans", type: :request do
  describe "GET /kairans" do
    it "works! (now write some real specs)" do
      get kairans_path
      expect(response).to have_http_status(200)
    end
  end
end
