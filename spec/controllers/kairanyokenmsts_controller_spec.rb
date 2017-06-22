require 'rails_helper'


RSpec.describe KairanyokenmstsController, type: :controller do
  fixtures :users
  # This should return the minimal set of attributes required to create a valid
  # Kairanyokenmst. As you add validations to Kairanyokenmst, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    {名称: "回覧", 備考: "０１", 優先さ: 2}
  }

  let(:invalid_attributes) {
    {名称: "回覧", 備考: "０１", 優先さ: 30}
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # KairanyokenmstsController. Be sure to keep this updated too.
  let(:valid_session) { {current_user_id: User.first.id} }

  describe "GET #index" do
    it "assigns all kairanyokenmsts as @kairanyokenmsts" do
      kairanyokenmst = Kairanyokenmst.create! valid_attributes
      get :index,session: valid_session
      expect(assigns(:kairanyokenmsts)).to eq([kairanyokenmst])
    end
  end

  describe "GET #show" do
    it "assigns the requested kairanyokenmst as @kairanyokenmst" do
      kairanyokenmst = Kairanyokenmst.create! valid_attributes
      get :show,params: {:id => kairanyokenmst.to_param},session: valid_session
      expect(assigns(:kairanyokenmst)).to eq(kairanyokenmst)
    end
  end

  describe "GET #new" do
    it "assigns a new kairanyokenmst as @kairanyokenmst" do
      get :new,session: valid_session
      expect(assigns(:kairanyokenmst)).to be_a_new(Kairanyokenmst)
    end
  end

  describe "GET #edit" do
    it "assigns the requested kairanyokenmst as @kairanyokenmst" do
      kairanyokenmst = Kairanyokenmst.create! valid_attributes
      get :edit,params: {:id => kairanyokenmst.to_param},session: valid_session
      expect(assigns(:kairanyokenmst)).to eq(kairanyokenmst)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Kairanyokenmst" do
        expect {
          post :create,params: {:kairanyokenmst => valid_attributes},session: valid_session
        }.to change(Kairanyokenmst, :count).by(1)
      end

      it "assigns a newly created kairanyokenmst as @kairanyokenmst" do
        post :create,params: {:kairanyokenmst => valid_attributes},session: valid_session
        expect(assigns(:kairanyokenmst)).to be_a(Kairanyokenmst)
        expect(assigns(:kairanyokenmst)).to be_persisted
      end

      it "redirects to the created kairanyokenmst" do
        post :create,params: {:kairanyokenmst => valid_attributes},session: valid_session
        expect(response).to redirect_to(kairanyokenmsts_path)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved kairanyokenmst as @kairanyokenmst" do
        post :create,params: {:kairanyokenmst => invalid_attributes},session: valid_session
        expect(assigns(:kairanyokenmst)).to be_a_new(Kairanyokenmst)
      end

      it "re-renders the 'new' template" do
        post :create,params: {:kairanyokenmst => invalid_attributes},session: valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        {備考: "hung"}
      }

      it "updates the requested kairanyokenmst" do
        kairanyokenmst = Kairanyokenmst.create! valid_attributes
        put :update,params: {:id => kairanyokenmst.to_param, :kairanyokenmst => new_attributes},session: valid_session
        kairanyokenmst.reload
        expect(kairanyokenmst.備考).to eq("hung")
      end

      it "assigns the requested kairanyokenmst as @kairanyokenmst" do
        kairanyokenmst = Kairanyokenmst.create! valid_attributes
        put :update,params: {:id => kairanyokenmst.to_param, :kairanyokenmst => valid_attributes},session: valid_session
        expect(assigns(:kairanyokenmst)).to eq(kairanyokenmst)
      end

      it "redirects to the kairanyokenmst" do
        kairanyokenmst = Kairanyokenmst.create! valid_attributes
        put :update,params: {:id => kairanyokenmst.to_param, :kairanyokenmst => valid_attributes},session: valid_session
        expect(response).to redirect_to(kairanyokenmsts_path)
      end
    end

    context "with invalid params" do
      it "assigns the kairanyokenmst as @kairanyokenmst" do
        kairanyokenmst = Kairanyokenmst.create! valid_attributes
        put :update,params: {:id => kairanyokenmst.to_param, :kairanyokenmst => invalid_attributes},session: valid_session
        expect(assigns(:kairanyokenmst)).to eq(kairanyokenmst)
      end

      it "re-renders the 'edit' template" do
        kairanyokenmst = Kairanyokenmst.create! valid_attributes
        put :update,params: {:id => kairanyokenmst.to_param, :kairanyokenmst => invalid_attributes},session: valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested kairanyokenmst" do
      kairanyokenmst = Kairanyokenmst.create! valid_attributes
      expect {
        delete :destroy,params: {:id => kairanyokenmst.to_param},session: valid_session
      }.to change(Kairanyokenmst, :count).by(-1)
    end

    it "redirects to the kairanyokenmsts list" do
      kairanyokenmst = Kairanyokenmst.create! valid_attributes
      delete :destroy,params: {:id => kairanyokenmst.to_param},session: valid_session
      expect(response).to redirect_to(kairanyokenmsts_url)
    end
  end

end
