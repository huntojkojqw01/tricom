require 'rails_helper'


RSpec.describe TsushinseigyousController, type: :controller do
  fixtures :users
  # This should return the minimal set of attributes required to create a valid
  # Tsushinseigyou. As you add validations to Tsushinseigyou, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # TsushinseigyousController. Be sure to keep this updated too.
  let(:valid_session) { {current_user_id: User.first.id} }

  # describe "GET #index" do
  #   it "assigns all tsushinseigyous as @tsushinseigyous" do
  #     tsushinseigyou = Tsushinseigyou.create! valid_attributes
  #     get :index,session: valid_session
  #     expect(assigns(:tsushinseigyous)).to eq([tsushinseigyou])
  #   end
  # end

  # describe "GET #show" do
  #   it "assigns the requested tsushinseigyou as @tsushinseigyou" do
  #     tsushinseigyou = Tsushinseigyou.create! valid_attributes
  #     get :show,params: {:id => tsushinseigyou.to_param},session: valid_session
  #     expect(assigns(:tsushinseigyou)).to eq(tsushinseigyou)
  #   end
  # end

  # describe "GET #new" do
  #   it "assigns a new tsushinseigyou as @tsushinseigyou" do
  #     get :new,session: valid_session
  #     expect(assigns(:tsushinseigyou)).to be_a_new(Tsushinseigyou)
  #   end
  # end

  # describe "GET #edit" do
  #   it "assigns the requested tsushinseigyou as @tsushinseigyou" do
  #     tsushinseigyou = Tsushinseigyou.create! valid_attributes
  #     get :edit,params: {:id => tsushinseigyou.to_param},session: valid_session
  #     expect(assigns(:tsushinseigyou)).to eq(tsushinseigyou)
  #   end
  # end

  # describe "POST #create" do
  #   context "with valid params" do
  #     it "creates a new Tsushinseigyou" do
  #       expect {
  #         post :create, {:tsushinseigyou => valid_attributes},session: valid_session
  #       }.to change(Tsushinseigyou, :count).by(1)
  #     end

  #     it "assigns a newly created tsushinseigyou as @tsushinseigyou" do
  #       post :create, {:tsushinseigyou => valid_attributes},session: valid_session
  #       expect(assigns(:tsushinseigyou)).to be_a(Tsushinseigyou)
  #       expect(assigns(:tsushinseigyou)).to be_persisted
  #     end

  #     it "redirects to the created tsushinseigyou" do
  #       post :create, {:tsushinseigyou => valid_attributes},session: valid_session
  #       expect(response).to redirect_to(Tsushinseigyou.last)
  #     end
  #   end

  #   context "with invalid params" do
  #     it "assigns a newly created but unsaved tsushinseigyou as @tsushinseigyou" do
  #       post :create, {:tsushinseigyou => invalid_attributes},session: valid_session
  #       expect(assigns(:tsushinseigyou)).to be_a_new(Tsushinseigyou)
  #     end

  #     it "re-renders the 'new' template" do
  #       post :create, {:tsushinseigyou => invalid_attributes},session: valid_session
  #       expect(response).to render_template("new")
  #     end
  #   end
  # end

  # describe "PUT #update" do
  #   context "with valid params" do
  #     let(:new_attributes) {
  #       skip("Add a hash of attributes valid for your model")
  #     }

  #     it "updates the requested tsushinseigyou" do
  #       tsushinseigyou = Tsushinseigyou.create! valid_attributes
  #       put :update,params: {:id => tsushinseigyou.to_param, :tsushinseigyou => new_attributes},session: valid_session
  #       tsushinseigyou.reload
  #       skip("Add assertions for updated state")
  #     end

  #     it "assigns the requested tsushinseigyou as @tsushinseigyou" do
  #       tsushinseigyou = Tsushinseigyou.create! valid_attributes
  #       put :update,params: {:id => tsushinseigyou.to_param, :tsushinseigyou => valid_attributes},session: valid_session
  #       expect(assigns(:tsushinseigyou)).to eq(tsushinseigyou)
  #     end

  #     it "redirects to the tsushinseigyou" do
  #       tsushinseigyou = Tsushinseigyou.create! valid_attributes
  #       put :update,params: {:id => tsushinseigyou.to_param, :tsushinseigyou => valid_attributes},session: valid_session
  #       expect(response).to redirect_to(tsushinseigyou)
  #     end
  #   end

  #   context "with invalid params" do
  #     it "assigns the tsushinseigyou as @tsushinseigyou" do
  #       tsushinseigyou = Tsushinseigyou.create! valid_attributes
  #       put :update,params: {:id => tsushinseigyou.to_param, :tsushinseigyou => invalid_attributes},session: valid_session
  #       expect(assigns(:tsushinseigyou)).to eq(tsushinseigyou)
  #     end

  #     it "re-renders the 'edit' template" do
  #       tsushinseigyou = Tsushinseigyou.create! valid_attributes
  #       put :update,params: {:id => tsushinseigyou.to_param, :tsushinseigyou => invalid_attributes},session: valid_session
  #       expect(response).to render_template("edit")
  #     end
  #   end
  # end

  # describe "DELETE #destroy" do
  #   it "destroys the requested tsushinseigyou" do
  #     tsushinseigyou = Tsushinseigyou.create! valid_attributes
  #     expect {
  #       delete :destroy,params: {:id => tsushinseigyou.to_param},session: valid_session
  #     }.to change(Tsushinseigyou, :count).by(-1)
  #   end

  #   it "redirects to the tsushinseigyous list" do
  #     tsushinseigyou = Tsushinseigyou.create! valid_attributes
  #     delete :destroy,params: {:id => tsushinseigyou.to_param},session: valid_session
  #     expect(response).to redirect_to(tsushinseigyous_url)
  #   end
  # end

end
