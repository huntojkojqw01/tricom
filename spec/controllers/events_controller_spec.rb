require 'rails_helper'

RSpec.describe EventsController, type: :controller do
  render_views
  before :each do
    user= User.find(10029)
    session[:user] = user.id
    session[:current_user_id] = user.id
    session[:selected_shain] = user.shainmaster.id
  end
  describe "GET #index" do
    it "has a 200 status code" do
      get :index
      expect(response.status).to eq(200)
    end
    it "renders the index template" do
      get :index
      expect(response).to render_template("index")
    end
  end

  describe "time_line_view" do
    it "renders an empty time_line_view template" do
      get :time_line_view
      expect(response).to render_template("time_line_view")
    end
  end

end
