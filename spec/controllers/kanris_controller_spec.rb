require 'rails_helper'

RSpec.describe KanrisController, type: :controller do
	fixtures :users
  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(302)
    end
  end

end
