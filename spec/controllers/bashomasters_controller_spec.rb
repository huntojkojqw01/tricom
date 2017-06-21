require 'rails_helper'
include SessionsHelper
RSpec.configure {|c| c.before { expect(controller).not_to be_nil }}

RSpec.describe BashomastersController, type: :controller do
  let(:valid_attributes) {
    {場所コード: 1122334455,
      場所名: "test 場所名",
      場所名カナ: "test 場所名カナ",
      SUB: "test",場所区分: '1',
      会社コード: "90000"}
  }

  let(:invalid_attributes) {
    {場所コード: 1122334455,
      場所名: nil,
      場所名カナ: "test 場所名カナ",
      SUB: "test",場所区分: '1',
      会社コード: "90000"}
  }
  let(:new_attributes) {
    {場所コード: 1122334455,
      場所名: "test 場所名 updated",
      場所名カナ: "test 場所名カナ updated",
      SUB: "test updated",場所区分: '2',
      会社コード: "90000"}
  }
  fixtures :bashomasters
  render_views
  before :each do
    user= User.find(10029)
    session[:user] = user.id
    session[:current_user_id] = user.id
    session[:selected_shain] = user.shainmaster.id
  end
  describe "GET #index" do
    it "populates an array of bashomasters" do
      get :index
      expect(assigns(:bashomasters)).to eq(Bashomaster.all)
    end
    it "has a 200 status code" do
      get :index
      expect(response.status).to eq(200)
    end
    it "renders the index template" do
      get :index
      expect(response).to render_template("index")
    end
  end

  describe "GET #show" do
    it "assigns the requested contact to @bashomaster" do
      bashomaster = bashomasters(:bashomaster_0)
      get :show, id: bashomaster
      expect(assigns(:bashomaster)).to eq(bashomaster)
    end

    it "renders the #show view" do
      get :show, id: bashomasters(:bashomaster_0)
      expect(response).to render_template :show
    end
  end

  describe "GET #new" do
    it "assigns a new bashomaster as @bashomaster" do
      get :new
      expect(assigns(:bashomaster)).to be_a_new(Bashomaster)
    end
  end

  describe "GET #edit" do
    it "assigns the requested bashomaster as @bashomaster" do
      bashomaster = Bashomaster.create! valid_attributes
      get :edit, {:id => bashomaster.id}
      expect(assigns(:bashomaster)).to eq(bashomaster)
    end
  end

  describe "POST create" do
    context "with valid attributes" do
      it "creates a new bashomaster" do
        expect{
          post :create, {:bashomaster => valid_attributes}
        }.to change(Bashomaster,:count).by(1)
        expect(flash[:notice]).to be_present
      end
      it "assigns a newly created bashomaster as @bashomaster" do
        post :create, {:bashomaster => valid_attributes}
        expect(assigns(:bashomaster)).to be_a(Bashomaster)
        expect(assigns(:bashomaster)).to be_persisted
        expect(flash[:notice]).to be_present
      end
      it "redirects to the created bashomaster" do
        post :create, {:bashomaster => valid_attributes}
        expect(response).to redirect_to Bashomaster.find_by(場所コード: 1122334455)
        expect(flash[:notice]).to be_present
      end
    end

    context "with invalid attributes" do
      it "does not save the new bashomaster" do
        expect{
          post :create, {:bashomaster => invalid_attributes}
        }.to_not change(Bashomaster,:count)
      end

      it "re-renders the new method" do
        post :create, {:bashomaster => invalid_attributes}
        expect(response).to render_template :new
      end
    end
  end

  describe 'PUT update' do
    before :each do
      @bashomaster = Bashomaster.create! valid_attributes
    end

    context "valid attributes" do
      it "updates the requested bashomaster" do
        put :update, {:id => @bashomaster.id, :bashomaster => new_attributes}
        @bashomaster.reload
        expect(@bashomaster.場所名).to eq("test 場所名 updated")
        expect(@bashomaster.場所名カナ).to eq("test 場所名カナ updated")
        expect(@bashomaster.SUB).to eq("test updated")
        expect(@bashomaster.場所区分).to eq("2")
        expect(flash[:notice]).to be_present
      end

      it "assigns the requested bashomaster as @bashomaster" do
        put :update, {:id => @bashomaster.id, :bashomaster => valid_attributes}
        expect(assigns(:bashomaster)).to eq(@bashomaster)
        expect(flash[:notice]).to be_present
      end

      it "redirects to the bashomaster" do
        put :update, {:id => @bashomaster.id, :bashomaster => valid_attributes}
        expect(response).to redirect_to(@bashomaster)
        expect(flash[:notice]).to be_present
      end
    end

    context "invalid attributes" do
      it "locates the requested @bashomaster" do
        put :update, {:id => @bashomaster.id, :bashomaster => invalid_attributes}
        expect(assigns(:bashomaster)).to eq(@bashomaster)
      end

      it "re-renders the edit method" do
        put :update, {:id => @bashomaster.id, :bashomaster => invalid_attributes}
        expect(response).to render_template :edit
      end
    end
  end

  describe "DELETE #destroy" do
    before :each do
      @bashomaster = Bashomaster.create! valid_attributes
    end
    it "destroys the requested bashomaster" do
      expect {
        delete :destroy, {:id => @bashomaster.id}
      }.to change(Bashomaster, :count).by(-1)
    end

    it "redirects to the bashomasters list" do
      delete :destroy, {:id => @bashomaster.id}
      expect(response).to redirect_to(bashomasters_url)
    end
  end
end
