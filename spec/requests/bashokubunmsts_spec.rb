require 'rails_helper'

RSpec.describe "Bashokubunmsts", type: :request do
  describe "GET /bashokubunmsts" do
    it "works! (now write some real specs)" do
      get bashokubunmsts_path
      expect(response).to have_http_status(200)
    end
  end
end
