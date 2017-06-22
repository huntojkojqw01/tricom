require 'rails_helper'


RSpec.describe KaishamastersController, type: :controller do
  fixtures :users
  # This should return the minimal set of attributes required to create a valid
  # Kaishamaster. As you add validations to Kaishamaster, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    {会社コード: "98765", 会社名: "アメンドライセンス", 備考: " "}
  }

  let(:invalid_attributes) {
    {会社名: "", 備考: " "}
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # KaishamastersController. Be sure to keep this updated too.
  let(:valid_session) { {current_user_id: User.first.id} }

  describe "GET #index" do
    it "assigns all kaishamasters as @kaishamasters" do      
      get :index,session: valid_session
      expect(assigns(:kaishamasters)).to eq(Kaishamaster.all)
    end
  end

  describe "GET #show" do
    it "assigns the requested kaishamaster as @kaishamaster" do
      kaishamaster = Kaishamaster.create! valid_attributes
      get :show,params: {:id => kaishamaster.to_param},session: valid_session
      expect(assigns(:kaishamaster)).to eq(kaishamaster)
    end
  end

  describe "GET #new" do
    it "assigns a new kaishamaster as @kaishamaster" do
      get :new,session: valid_session
      expect(assigns(:kaishamaster)).to be_a_new(Kaishamaster)
    end
  end

  describe "GET #edit" do
    it "assigns the requested kaishamaster as @kaishamaster" do
      kaishamaster = Kaishamaster.create! valid_attributes
      get :edit,params: {:id => kaishamaster.to_param},session: valid_session
      expect(assigns(:kaishamaster)).to eq(kaishamaster)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Kaishamaster" do
        expect {
          post :create,params: {:kaishamaster => valid_attributes},session: valid_session
        }.to change(Kaishamaster, :count).by(1)
      end

      it "assigns a newly created kaishamaster as @kaishamaster" do
        post :create,params: {:kaishamaster => valid_attributes},session: valid_session
        expect(assigns(:kaishamaster)).to be_a(Kaishamaster)
        expect(assigns(:kaishamaster)).to be_persisted
      end

      it "redirects to the created kaishamaster" do
        post :create,params: {:kaishamaster => valid_attributes},session: valid_session
        expect(response).to redirect_to(Kaishamaster.last)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved kaishamaster as @kaishamaster" do
        post :create,params: {:kaishamaster => invalid_attributes},session: valid_session
        expect(assigns(:kaishamaster)).to be_a_new(Kaishamaster)
      end

      it "re-renders the 'new' template" do
        post :create,params: {:kaishamaster => invalid_attributes},session: valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        {会社名: "CMC"}
      }

      it "updates the requested kaishamaster" do
        kaishamaster = Kaishamaster.create! valid_attributes
        put :update,params: {:id => kaishamaster.to_param, :kaishamaster => new_attributes},session: valid_session
        kaishamaster.reload
        expect(kaishamaster.会社名).to eq("CMC")
      end

      it "assigns the requested kaishamaster as @kaishamaster" do
        kaishamaster = Kaishamaster.create! valid_attributes
        put :update,params: {:id => kaishamaster.to_param, :kaishamaster => valid_attributes},session: valid_session
        expect(assigns(:kaishamaster)).to eq(kaishamaster)
      end

      it "redirects to the kaishamaster" do
        kaishamaster = Kaishamaster.create! valid_attributes
        put :update,params: {:id => kaishamaster.to_param, :kaishamaster => valid_attributes},session: valid_session
        expect(response).to redirect_to(kaishamaster)
      end
    end

    context "with invalid params" do
      it "assigns the kaishamaster as @kaishamaster" do
        kaishamaster = Kaishamaster.create! valid_attributes
        put :update,params: {:id => kaishamaster.to_param, :kaishamaster => invalid_attributes},session: valid_session
        expect(assigns(:kaishamaster)).to eq(kaishamaster)
      end

      it "re-renders the 'edit' template" do
        kaishamaster = Kaishamaster.create! valid_attributes
        put :update,params: {:id => kaishamaster.to_param, :kaishamaster => invalid_attributes},session: valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested kaishamaster" do
      kaishamaster = Kaishamaster.create! valid_attributes
      expect {
        delete :destroy,params: {:id => kaishamaster.to_param},session: valid_session
      }.to change(Kaishamaster, :count).by(-1)
    end

    it "redirects to the kaishamasters list" do
      kaishamaster = Kaishamaster.create! valid_attributes
      delete :destroy,params: {:id => kaishamaster.to_param},session: valid_session
      expect(response).to redirect_to(kaishamasters_url)
    end
  end

end
