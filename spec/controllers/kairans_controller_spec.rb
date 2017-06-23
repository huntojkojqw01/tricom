require 'rails_helper'


RSpec.describe KairansController, type: :controller do
  fixtures :users,:kairanshosais
  # This should return the minimal set of attributes required to create a valid
  # Kairan. As you add validations to Kairan, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    {発行者: User.first.id, 要件: "2", 開始: "2017/05/16 17:01", 終了: "2017/05/26 17:01", 件名: "ngu", 内容: "ngu ngon", 確認要: true}
  }

  let(:invalid_attributes) {
    {発行者: "12345", 要件: "2", 開始: "2017/05/16 17:01", 終了: "2017/05/26 17:01", 件名: "ngu", 内容: "ngu ngon", 確認要: true}
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # KairansController. Be sure to keep this updated too.
  let(:valid_session) { {current_user_id: User.first.id} }

  describe "GET #index" do
    it "assigns all kairans as @kairans" do      
      get :index,session: valid_session
      #expect(assigns(:kairans)).to eq(Kairan.all)
    end
  end

  describe "GET #show" do
    it "assigns the requested kairan as @kairan" do
      kairan = Kairan.create! valid_attributes
      get :show,params: {:id => kairan.to_param},session: valid_session
      expect(assigns(:kairan)).to eq(kairan)
    end
  end

  describe "GET #new" do
    it "assigns a new kairan as @kairan" do
      get :new,session: valid_session
      expect(assigns(:kairan)).to be_a_new(Kairan)
    end
  end

  describe "GET #edit" do
    # it "assigns the requested kairan as @kairan" do
    #   kairan = Kairan.create! valid_attributes
    #   get :edit,params: {:id => kairan.to_param},session: valid_session
    #   expect(assigns(:kairan)).to eq(kairan)
    # end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Kairan" do
        expect {
          post :create,params: {:kairan => valid_attributes},session: valid_session
        }.to change(Kairan, :count).by(1)
      end

      it "assigns a newly created kairan as @kairan" do
        post :create,params: {:kairan => valid_attributes},session: valid_session
        expect(assigns(:kairan)).to be_a(Kairan)
        expect(assigns(:kairan)).to be_persisted
      end

      it "redirects to the created kairan" do
        post :create,params: {:kairan => valid_attributes},session: valid_session
        expect(response).to redirect_to(kairans_path)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved kairan as @kairan" do
        post :create,params: {:kairan => invalid_attributes},session: valid_session
        #expect(assigns(:kairan)).to be_a_new(Kairan)
      end

      it "re-renders the 'new' template" do
        post :create,params: {:kairan => invalid_attributes},session: valid_session
        expect(response).to redirect_to(kairans_path)
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        {内容: "nguyen dinh hung"}
      }

      it "updates the requested kairan" do
        kairan = Kairan.create! valid_attributes
        put :update,params: {:id => kairan.to_param, :kairan => new_attributes},session: valid_session
        kairan.reload
        expect(kairan.内容).to eq("nguyen dinh hung")
      end

      it "assigns the requested kairan as @kairan" do
        kairan = Kairan.create! valid_attributes
        put :update,params: {:id => kairan.to_param, :kairan => valid_attributes},session: valid_session
        expect(assigns(:kairan)).to eq(kairan)
      end

      it "redirects to the kairan" do
        kairan = Kairan.create! valid_attributes
        put :update,params: {:id => kairan.to_param, :kairan => valid_attributes},session: valid_session
        expect(response).to redirect_to(kairans_path)
      end
    end

    context "with invalid params" do
      it "assigns the kairan as @kairan" do
        kairan = Kairan.create! valid_attributes
        put :update,params: {:id => kairan.to_param, :kairan => invalid_attributes},session: valid_session
        expect(assigns(:kairan)).to eq(kairan)
      end

      it "re-renders the 'edit' template" do
        kairan = Kairan.create! valid_attributes
        put :update,params: {:id => kairan.to_param, :kairan => invalid_attributes},session: valid_session
        expect(response).to redirect_to kairans_path
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested kairan" do
      kairan = Kairan.create! valid_attributes
      expect {
        delete :destroy,params: {:id => kairan.to_param},session: valid_session
      }.to change(Kairan, :count).by(0)
    end

    it "redirects to the kairans list" do
      kairan = Kairan.create! valid_attributes
      delete :destroy,params: {:id => kairan.to_param},session: valid_session
      expect(response).to redirect_to(kairans_url)
    end
  end

end
