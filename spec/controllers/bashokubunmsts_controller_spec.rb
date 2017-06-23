require 'rails_helper'

RSpec.describe BashokubunmstsController, type: :controller do
  fixtures :bashokubunmsts,:users
  let(:valid_attributes) {
    {場所区分コード: "100", 場所区分名: "1234"}
  }

  let(:invalid_attributes) {
    {場所区分コード: "1", 場所区分名: "1234"}
  }
  
  let(:valid_session) { {current_user_id: User.first.id} }

  describe "GET #index" do
    it "assigns all bashokubunmsts as @bashokubunmsts" do      
      get :index,session: valid_session
      expect(assigns(:bashokubunmsts)).to eq(Bashokubunmst.all)
    end
  end

  describe "GET #show" do
    it "assigns the requested bashokubunmst as @bashokubunmst" do
      bashokubunmst = Bashokubunmst.first
      get :show,params: {:id => bashokubunmst.to_param},session: valid_session
      expect(assigns(:bashokubunmst)).to eq(bashokubunmst)
    end
  end

  describe "GET #new" do
    it "assigns a new bashokubunmst as @bashokubunmst" do
      get :new, session: valid_session
      expect(assigns(:bashokubunmst)).to be_a_new(Bashokubunmst)
    end
  end

  describe "GET #edit" do
    it "assigns the requested bashokubunmst as @bashokubunmst" do
      bashokubunmst = Bashokubunmst.first
      get :edit,params: {:id => bashokubunmst.to_param},session: valid_session
      expect(assigns(:bashokubunmst)).to eq(bashokubunmst)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Bashokubunmst" do
        expect {
          post :create, params: {:bashokubunmst => valid_attributes},session: valid_session
        }.to change(Bashokubunmst, :count).by(1)
      end

      it "assigns a newly created bashokubunmst as @bashokubunmst" do
        post :create,params: {:bashokubunmst => valid_attributes},session: valid_session
        expect(assigns(:bashokubunmst)).to be_a(Bashokubunmst)
        expect(assigns(:bashokubunmst)).to be_persisted
      end

      it "redirects to the created bashokubunmst" do
        post :create,params: {:bashokubunmst => valid_attributes},session: valid_session
        expect(response).to redirect_to(Bashokubunmst.order("created_at").last)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved bashokubunmst as @bashokubunmst" do
        post :create,params: {:bashokubunmst => invalid_attributes},session: valid_session
        expect(assigns(:bashokubunmst)).to be_a_new(Bashokubunmst)
      end

      it "re-renders the 'new' template" do
        post :create,params: {:bashokubunmst => invalid_attributes},session: valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        {場所区分名: "5678"}
      }

      it "updates the requested bashokubunmst" do
        bashokubunmst = Bashokubunmst.first
        put :update,params: {:id => bashokubunmst.to_param, :bashokubunmst => new_attributes},session: valid_session
        bashokubunmst.reload
        expect(bashokubunmst.場所区分名).to eq("5678")
      end

      it "assigns the requested bashokubunmst as @bashokubunmst" do
        bashokubunmst = Bashokubunmst.first
        put :update,params: {:id => bashokubunmst.to_param, :bashokubunmst => new_attributes},session: valid_session
        bashokubunmst.reload
        expect(assigns(:bashokubunmst)).to eq(bashokubunmst)
      end

      it "redirects to the bashokubunmst" do
        bashokubunmst = Bashokubunmst.first
        put :update,params: {:id => bashokubunmst.to_param, :bashokubunmst => new_attributes},session: valid_session
        expect(response).to redirect_to(bashokubunmst)
      end
    end

    context "with invalid params" do
      it "assigns the bashokubunmst as @bashokubunmst" do
        bashokubunmst = Bashokubunmst.first
        put :update,params: {:id => bashokubunmst.to_param, :bashokubunmst => invalid_attributes},session: valid_session
        expect(assigns(:bashokubunmst)).to eq(bashokubunmst)
      end

      it "re-renders the 'edit' template" do
        bashokubunmst = Bashokubunmst.first
        put :update,params: {:id => bashokubunmst.to_param, :bashokubunmst => invalid_attributes},session: valid_session
        expect(response).to redirect_to bashokubunmst
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested bashokubunmst" do
      bashokubunmst = Bashokubunmst.first
      expect {
        delete :destroy,params: {:id => bashokubunmst.to_param},session: valid_session
      }.to change(Bashokubunmst, :count).by(-1)
    end

    it "redirects to the bashokubunmsts list" do
      bashokubunmst = Bashokubunmst.first
      delete :destroy,params: {:id => bashokubunmst.to_param},session: valid_session
      expect(response).to redirect_to(bashokubunmsts_url)
    end
  end

end
