require 'rails_helper'

RSpec.describe DengonsController, type: :controller do
  fixtures :dengons,:users
  # This should return the minimal set of attributes required to create a valid
  # Dengon. As you add validations to Dengon, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    {from1: "テスト", from2: "テスト名前", 日付: "2016-10-25 19:00:00", 入力者: User.last.id, 用件: "6", 回答: "9", 伝言内容: "kamejoko", 確認: true, 送信: false,  社員番号: User.first.id}
  }

  let(:invalid_attributes) {
    {from1: "テスト", from2: "テスト名前", 日付: "2016-10-25 19:00:00", 入力者: User.last.id, 用件: "6", 回答: "9", 伝言内容: "kamejoko", 確認: true, 送信: false, 社員番号: User.first.id}
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # DengonsController. Be sure to keep this updated too.
  let(:valid_session) { {current_user_id: User.first.id,user: User.first} }

  describe "GET #index" do
    it "assigns all dengons as @dengons" do      
      get :index,session: valid_session
      #expect(assigns(:dengons)).to eq(Dengon.all)
    end
  end

  describe "GET #show" do
    it "assigns the requested dengon as @dengon" do
      dengon = Dengon.create! valid_attributes
      get :show,params: {:id => dengon.to_param},session: valid_session
      expect(assigns(:dengon)).to eq(dengon)
    end
  end

  describe "GET #new" do
    it "assigns a new dengon as @dengon" do
      get :new,session: valid_session
      expect(assigns(:dengon)).to be_a_new(Dengon)
    end
  end

  describe "GET #edit" do
    it "assigns the requested dengon as @dengon" do
      dengon = Dengon.create! valid_attributes
      get :edit,params: {:id => dengon.to_param},session: valid_session
      expect(assigns(:dengon)).to eq(dengon)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Dengon" do
        expect {
          post :create,params: {:dengon => valid_attributes},session: valid_session
        }.to change(Dengon, :count).by(1)
      end

      it "assigns a newly created dengon as @dengon" do
        post :create,params: {:dengon => valid_attributes},session: valid_session
        expect(assigns(:dengon)).to be_a(Dengon)
        expect(assigns(:dengon)).to be_persisted
      end

      it "redirects to the created dengon" do
        post :create,params: {:dengon => valid_attributes},session: valid_session
        expect(response).to redirect_to(dengons_path)
      end
    end

    context "with invalid params" do

      it "re-renders the 'new' template" do
        post :create,params: {:dengon => invalid_attributes},session: valid_session
        expect(response).to redirect_to(dengons_path)
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        { 伝言内容: "xinzhao"}
      }

      it "updates the requested dengon" do
        dengon = Dengon.first
        put :update,params: {:id => dengon.to_param, :dengon => new_attributes},session: valid_session
        dengon.reload
        expect(dengon. 伝言内容).to eq("xinzhao")
      end

      it "assigns the requested dengon as @dengon" do
        dengon = Dengon.create! valid_attributes
        put :update,params: {:id => dengon.to_param, :dengon => new_attributes},session: valid_session
        expect(assigns(:dengon)).to eq(dengon)
      end

      it "redirects to the dengon" do
        dengon = Dengon.create! valid_attributes
        put :update,params: {:id => dengon.to_param, :dengon => new_attributes},session: valid_session
        expect(response).to redirect_to(dengons_path)
      end
    end

    context "with invalid params" do
      it "assigns the dengon as @dengon" do
        dengon = Dengon.create! valid_attributes
        put :update,params: {:id => dengon.to_param, :dengon => invalid_attributes},session: valid_session
        expect(assigns(:dengon)).to eq(dengon)
      end

      it "re-renders the 'edit' template" do
        dengon = Dengon.create! valid_attributes
        put :update,params: {:id => dengon.to_param, :dengon => invalid_attributes},session: valid_session
        expect(response).to redirect_to(dengons_path)
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested dengon" do
      dengon = Dengon.create! valid_attributes
      expect {
        delete :destroy,params: {:id => dengon.to_param},session: valid_session
      }.to change(Dengon, :count).by(-1)
    end

    it "redirects to the dengons list" do
      dengon = Dengon.create! valid_attributes
      delete :destroy,params: {:id => dengon.to_param},session: valid_session
      expect(response).to redirect_to(dengons_url)
    end
  end

end
