require 'rails_helper'
RSpec.describe BunruisController, type: :controller do
  fixtures :users
  let(:valid_attributes) {
    {分類コード: "1234", 分類名: "hung"}
  }

  let(:invalid_attributes) {
    {分類コード: "1234", 分類名: ""}
  }
  
  let(:valid_session) { {current_user_id: User.first.id} }

  describe "GET #index" do
    it "assigns all bunruis as @bunruis" do
      bunrui = Bunrui.create! valid_attributes
      get :index,session: valid_session
      expect(assigns(:bunruis)).to eq([bunrui])
    end
  end

  describe "GET #show" do
    it "assigns the requested bunrui as @bunrui" do
      bunrui = Bunrui.create! valid_attributes
      get :show,params: {:id => bunrui.to_param},session: valid_session
      expect(assigns(:bunrui)).to eq(bunrui)
    end
  end

  describe "GET #new" do
    it "assigns a new bunrui as @bunrui" do
      get :new,session: valid_session
      expect(assigns(:bunrui)).to be_a_new(Bunrui)
    end
  end

  describe "GET #edit" do
    it "assigns the requested bunrui as @bunrui" do
      bunrui = Bunrui.create! valid_attributes
      get :edit,params: {:id => bunrui.to_param},session: valid_session
      expect(assigns(:bunrui)).to eq(bunrui)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Bunrui" do
        expect {
          post :create,params: {:bunrui => valid_attributes},session: valid_session
        }.to change(Bunrui, :count).by(1)
      end

      it "assigns a newly created bunrui as @bunrui" do
        post :create,params: {:bunrui => valid_attributes},session: valid_session
        expect(assigns(:bunrui)).to be_a(Bunrui)
        expect(assigns(:bunrui)).to be_persisted
      end

      it "redirects to the created bunrui" do
        post :create,params: {:bunrui => valid_attributes},session: valid_session
        expect(response).to redirect_to(Bunrui.last)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved bunrui as @bunrui" do
        post :create,params: {:bunrui => invalid_attributes},session: valid_session
        expect(assigns(:bunrui)).to be_a_new(Bunrui)
      end

      it "re-renders the 'new' template" do
        post :create,params: {:bunrui => invalid_attributes},session: valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        {分類名: "hero nguyen"}
      }

      it "updates the requested bunrui" do
        bunrui = Bunrui.create! valid_attributes
        put :update,params: {:id => bunrui.to_param, :bunrui => new_attributes},session: valid_session
        bunrui.reload
        expect(bunrui.分類名).to eq("hero nguyen")
      end

      it "assigns the requested bunrui as @bunrui" do
        bunrui = Bunrui.create! valid_attributes
        put :update,params: {:id => bunrui.to_param, :bunrui => new_attributes},session: valid_session
        expect(assigns(:bunrui)).to eq(bunrui)
      end

      it "redirects to the bunrui" do
        bunrui = Bunrui.create! valid_attributes
        put :update,params: {:id => bunrui.to_param, :bunrui => new_attributes},session: valid_session
        expect(response).to redirect_to(bunrui)
      end
    end

    context "with invalid params" do
      it "assigns the bunrui as @bunrui" do
        bunrui = Bunrui.create! valid_attributes
        put :update,params: {:id => bunrui.to_param, :bunrui => invalid_attributes},session: valid_session
        expect(assigns(:bunrui)).to eq(bunrui)
      end

      it "re-renders the 'edit' template" do
        bunrui = Bunrui.create! valid_attributes
        put :update,params: {:id => bunrui.to_param, :bunrui => invalid_attributes},session: valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested bunrui" do
      bunrui = Bunrui.create! valid_attributes
      expect {
        delete :destroy,params: {:id => bunrui.to_param},session: valid_session
      }.to change(Bunrui, :count).by(-1)
    end

    it "redirects to the bunruis list" do
      bunrui = Bunrui.create! valid_attributes
      delete :destroy,params: {:id => bunrui.to_param},session: valid_session
      expect(response).to redirect_to(bunruis_url)
    end
  end

end
