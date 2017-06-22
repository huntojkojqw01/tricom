require 'rails_helper'


RSpec.describe DengonkaitousController, type: :controller do
  fixtures :users
  let(:valid_attributes) {
    {種類名: "至急電話1", 備考: "０１1"}
  }

  let(:invalid_attributes) {
    {種類名: "", 備考: ""}
  }

  
  let(:valid_session) { {current_user_id: User.first.id} }

  describe "GET #index" do
    it "assigns all dengonkaitous as @dengonkaitous" do
      dengonkaitou = Dengonkaitou.create! valid_attributes
      get :index,session: valid_session
      expect(assigns(:dengonkaitous)).to eq([dengonkaitou])
    end
  end

  describe "GET #show" do
    it "assigns the requested dengonkaitou as @dengonkaitou" do
      dengonkaitou = Dengonkaitou.create! valid_attributes
      get :show,params: {:id => dengonkaitou.to_param},session: valid_session
      expect(assigns(:dengonkaitou)).to eq(dengonkaitou)
    end
  end

  describe "GET #new" do
    it "assigns a new dengonkaitou as @dengonkaitou" do
      get :new,session: valid_session
      expect(assigns(:dengonkaitou)).to be_a_new(Dengonkaitou)
    end
  end

  describe "GET #edit" do
    it "assigns the requested dengonkaitou as @dengonkaitou" do
      dengonkaitou = Dengonkaitou.create! valid_attributes
      get :edit,params: {:id => dengonkaitou.to_param},session: valid_session
      expect(assigns(:dengonkaitou)).to eq(dengonkaitou)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Dengonkaitou" do
        expect {
          post :create,params: {:dengonkaitou => valid_attributes},session: valid_session
        }.to change(Dengonkaitou, :count).by(1)
      end

      it "assigns a newly created dengonkaitou as @dengonkaitou" do
        post :create,params: {:dengonkaitou => valid_attributes},session: valid_session
        expect(assigns(:dengonkaitou)).to be_a(Dengonkaitou)
        expect(assigns(:dengonkaitou)).to be_persisted
      end

      it "redirects to the created dengonkaitou" do
        post :create,params: {:dengonkaitou => valid_attributes},session: valid_session
        expect(response).to redirect_to(dengonkaitous_url)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved dengonkaitou as @dengonkaitou" do
        post :create,params: {:dengonkaitou => invalid_attributes},session: valid_session
        expect(assigns(:dengonkaitou)).to be_a_new(Dengonkaitou)
      end

      it "re-renders the 'new' template" do
        post :create,params: {:dengonkaitou => invalid_attributes},session: valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        {備考: "1234"}
      }

      it "updates the requested dengonkaitou" do
        dengonkaitou = Dengonkaitou.create! valid_attributes
        put :update,params: {:id => dengonkaitou.to_param, :dengonkaitou => new_attributes},session: valid_session
        dengonkaitou.reload
        expect(dengonkaitou.備考).to eq("1234")
      end

      it "assigns the requested dengonkaitou as @dengonkaitou" do
        dengonkaitou = Dengonkaitou.create! valid_attributes
        put :update,params: {:id => dengonkaitou.to_param, :dengonkaitou => valid_attributes},session: valid_session
        expect(assigns(:dengonkaitou)).to eq(dengonkaitou)
      end

      it "redirects to the dengonkaitou" do
        dengonkaitou = Dengonkaitou.create! valid_attributes
        put :update,params: {:id => dengonkaitou.to_param, :dengonkaitou => valid_attributes},session: valid_session
        expect(response).to redirect_to(dengonkaitous_url)
      end
    end

    context "with invalid params" do
      it "assigns the dengonkaitou as @dengonkaitou" do
        dengonkaitou = Dengonkaitou.create! valid_attributes
        put :update,params: {:id => dengonkaitou.to_param, :dengonkaitou => invalid_attributes},session: valid_session
        expect(assigns(:dengonkaitou)).to eq(dengonkaitou)
      end

      it "re-renders the 'edit' template" do
        dengonkaitou = Dengonkaitou.create! valid_attributes
        put :update,params: {:id => dengonkaitou.to_param, :dengonkaitou => invalid_attributes},session: valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested dengonkaitou" do
      dengonkaitou = Dengonkaitou.create! valid_attributes
      expect {
        delete :destroy,params: {:id => dengonkaitou.to_param},session: valid_session
      }.to change(Dengonkaitou, :count).by(-1)
    end

    it "redirects to the dengonkaitous list" do
      dengonkaitou = Dengonkaitou.create! valid_attributes
      delete :destroy,params: {:id => dengonkaitou.to_param},session: valid_session
      expect(response).to redirect_to(dengonkaitous_url)
    end
  end

end
