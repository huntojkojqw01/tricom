require 'rails_helper'

RSpec.describe JobmastersController, type: :controller do
  fixtures :users,:kaishamasters
  # This should return the minimal set of attributes required to create a valid
  # Jobmaster. As you add validations to Jobmaster, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    {job番号: "00049", job名: "ﾊﾟﾌｫｰﾏﾝｽ管理ｼｽﾃﾑ", 開始日: "2014-01-01", 終了日: "2099-12-31", ユーザ番号: Kaishamaster.first.id, ユーザ名: "デリフレッシュフーズ", 入力社員番号: User.first.id}
  }

  let(:invalid_attributes) {
    {job名: "", 開始日: "2014-01-01", 終了日: "2099-12-31", ユーザ番号: Kaishamaster.first.id, ユーザ名: "デリフレッシュフーズ", 入力社員番号: User.first.id}
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # JobmastersController. Be sure to keep this updated too.
  let(:valid_session) { {current_user_id: User.first.id} }

  describe "GET #index" do
    it "assigns all jobmasters as @jobmasters" do      
      get :index,session: valid_session
      expect(assigns(:jobmasters)).to eq(Jobmaster.all)
    end
  end

  describe "GET #show" do
    it "assigns the requested jobmaster as @jobmaster" do
      jobmaster = Jobmaster.create! valid_attributes
      get :show,params: {:id => jobmaster.to_param},session: valid_session
      expect(assigns(:jobmaster)).to eq(jobmaster)
    end
  end

  describe "GET #new" do
    it "assigns a new jobmaster as @jobmaster" do
      get :new,session: valid_session
      expect(assigns(:jobmaster)).to be_a_new(Jobmaster)
    end
  end

  describe "GET #edit" do
    it "assigns the requested jobmaster as @jobmaster" do
      jobmaster = Jobmaster.create! valid_attributes
      get :edit,params: {:id => jobmaster.to_param},session: valid_session
      expect(assigns(:jobmaster)).to eq(jobmaster)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Jobmaster" do
        expect {
          post :create,params: {:jobmaster => valid_attributes},session: valid_session
        }.to change(Jobmaster, :count).by(1)
      end

      it "assigns a newly created jobmaster as @jobmaster" do
        post :create,params: {:jobmaster => valid_attributes},session: valid_session
        expect(assigns(:jobmaster)).to be_a(Jobmaster)
        expect(assigns(:jobmaster)).to be_persisted
      end

      it "redirects to the created jobmaster" do
        post :create,params: {:jobmaster => valid_attributes},session: valid_session
        expect(response).to redirect_to(jobmasters_path)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved jobmaster as @jobmaster" do
        post :create,params: {:jobmaster => invalid_attributes},session: valid_session
        expect(assigns(:jobmaster)).to be_a_new(Jobmaster)
      end

      it "re-renders the 'new' template" do
        post :create,params: {:jobmaster => invalid_attributes},session: valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        {job名: "hung"}
      }

      it "updates the requested jobmaster" do
        jobmaster = Jobmaster.create! valid_attributes
        put :update,params: {:id => jobmaster.to_param, :jobmaster => new_attributes},session: valid_session
        jobmaster.reload
        expect(jobmaster.job名).to eq("hung")
      end

      it "assigns the requested jobmaster as @jobmaster" do
        jobmaster = Jobmaster.create! valid_attributes
        put :update,params: {:id => jobmaster.to_param, :jobmaster => valid_attributes},session: valid_session
        expect(assigns(:jobmaster)).to eq(jobmaster)
      end

      it "redirects to the jobmaster" do
        jobmaster = Jobmaster.create! valid_attributes
        put :update,params: {:id => jobmaster.to_param, :jobmaster => valid_attributes},session: valid_session
        expect(response).to redirect_to(jobmasters_path)
      end
    end

    context "with invalid params" do
      it "assigns the jobmaster as @jobmaster" do
        jobmaster = Jobmaster.create! valid_attributes
        put :update,params: {:id => jobmaster.to_param, :jobmaster => invalid_attributes},session: valid_session
        expect(assigns(:jobmaster)).to eq(jobmaster)
      end

      it "re-renders the 'edit' template" do
        jobmaster = Jobmaster.create! valid_attributes
        put :update,params: {:id => jobmaster.to_param, :jobmaster => invalid_attributes},session: valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested jobmaster" do
      jobmaster = Jobmaster.create! valid_attributes
      expect {
        delete :destroy,params: {:id => jobmaster.to_param},session: valid_session
      }.to change(Jobmaster, :count).by(-1)
    end

    it "redirects to the jobmasters list" do
      jobmaster = Jobmaster.create! valid_attributes
      delete :destroy,params: {:id => jobmaster.to_param},session: valid_session
      expect(response).to redirect_to(jobmasters_url)
    end
  end

end
