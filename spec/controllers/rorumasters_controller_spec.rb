require 'rails_helper'

RSpec.describe RorumastersController, type: :controller do
	fixtures :users
  describe "GET #new" do
    it "returns http success" do
      get :new
      expect(response).to have_http_status(302)
    end
  end

end
