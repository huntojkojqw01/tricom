require 'rails_helper'

RSpec.describe ShainController, type: :controller do

  describe "GET #index" do
    it "returns http success" do
      get :index_old
      expect(response).to have_http_status(:success)
    end
  end

end
