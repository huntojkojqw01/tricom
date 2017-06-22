require 'rails_helper'

RSpec.describe DengonyoukensController, type: :controller do
  fixtures :users,:yuusens
  # This should return the minimal set of attributes required to create a valid
  # Dengonyouken. As you add validations to Dengonyouken, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    {種類名: "電話", 備考: "０１", color: nil, 優先さ: 7}
  }

  let(:invalid_attributes) {
    {種類名: "電話", 備考: "０１", color: nil, 優先さ: 30}
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # DengonyoukensController. Be sure to keep this updated too.
  let(:valid_session) { {current_user_id: User.first.id} }

  describe "GET #index" do
    it "assigns all dengonyoukens as @dengonyoukens" do
      dengonyouken = Dengonyouken.create! valid_attributes
      get :index,session: valid_session
      expect(assigns(:dengonyoukens)).to eq([dengonyouken])
    end
  end

  describe "GET #show" do
    it "assigns the requested dengonyouken as @dengonyouken" do
      dengonyouken = Dengonyouken.create! valid_attributes
      get :show,params: {:id => dengonyouken.to_param},session: valid_session
      expect(assigns(:dengonyouken)).to eq(dengonyouken)
    end
  end

  describe "GET #new" do
    it "assigns a new dengonyouken as @dengonyouken" do
      get :new,session: valid_session
      expect(assigns(:dengonyouken)).to be_a_new(Dengonyouken)
    end
  end

  describe "GET #edit" do
    it "assigns the requested dengonyouken as @dengonyouken" do
      dengonyouken = Dengonyouken.create! valid_attributes
      get :edit,params: {:id => dengonyouken.to_param},session: valid_session
      expect(assigns(:dengonyouken)).to eq(dengonyouken)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Dengonyouken" do
        expect {
          post :create,params: {:dengonyouken => valid_attributes},session: valid_session
        }.to change(Dengonyouken, :count).by(1)
      end

      it "assigns a newly created dengonyouken as @dengonyouken" do
        post :create,params: {:dengonyouken => valid_attributes},session: valid_session
        expect(assigns(:dengonyouken)).to be_a(Dengonyouken)
        expect(assigns(:dengonyouken)).to be_persisted
      end

      it "redirects to the created dengonyouken" do
        post :create,params: {:dengonyouken => valid_attributes},session: valid_session
        expect(response).to redirect_to(dengonyoukens_path)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved dengonyouken as @dengonyouken" do
        post :create,params: {:dengonyouken => invalid_attributes},session: valid_session
        expect(assigns(:dengonyouken)).to be_a_new(Dengonyouken)
      end

      it "re-renders the 'new' template" do
        post :create,params: {:dengonyouken => invalid_attributes},session: valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        {種類名: "hung"}
      }

      it "updates the requested dengonyouken" do
        dengonyouken = Dengonyouken.create! valid_attributes
        put :update,params: {:id => dengonyouken.to_param, :dengonyouken => new_attributes},session: valid_session
        dengonyouken.reload
        expect(dengonyouken.種類名).to eq("hung")
      end

      it "assigns the requested dengonyouken as @dengonyouken" do
        dengonyouken = Dengonyouken.create! valid_attributes
        put :update,params: {:id => dengonyouken.to_param, :dengonyouken => valid_attributes},session: valid_session
        expect(assigns(:dengonyouken)).to eq(dengonyouken)
      end

      it "redirects to the dengonyouken" do
        dengonyouken = Dengonyouken.create! valid_attributes
        put :update,params: {:id => dengonyouken.to_param, :dengonyouken => valid_attributes},session: valid_session
        expect(response).to redirect_to(dengonyoukens_path)
      end
    end

    context "with invalid params" do
      it "assigns the dengonyouken as @dengonyouken" do
        dengonyouken = Dengonyouken.create! valid_attributes
        put :update,params: {:id => dengonyouken.to_param, :dengonyouken => invalid_attributes},session: valid_session
        expect(assigns(:dengonyouken)).to eq(dengonyouken)
      end

      it "re-renders the 'edit' template" do
        dengonyouken = Dengonyouken.create! valid_attributes
        put :update,params: {:id => dengonyouken.to_param, :dengonyouken => invalid_attributes},session: valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested dengonyouken" do
      dengonyouken = Dengonyouken.create! valid_attributes
      expect {
        delete :destroy,params: {:id => dengonyouken.to_param},session: valid_session
      }.to change(Dengonyouken, :count).by(-1)
    end

    it "redirects to the dengonyoukens list" do
      dengonyouken = Dengonyouken.create! valid_attributes
      delete :destroy,params: {:id => dengonyouken.to_param},session: valid_session
      expect(response).to redirect_to(dengonyoukens_url)
    end
  end

end
