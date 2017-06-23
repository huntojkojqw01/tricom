require 'rails_helper'


RSpec.describe KintaisController, type: :controller do
  fixtures :users
  # This should return the minimal set of attributes required to create a valid
  # Kintai. As you add validations to Kintai, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # KintaisController. Be sure to keep this updated too.
  let(:valid_session) { {current_user_id: User.first.id} }

  # describe "GET #index" do
  #   it "assigns all kintais as @kintais" do
  #     kintai = Kintai.create! valid_attributes
  #     get :index,session: valid_session
  #     expect(assigns(:kintais)).to eq([kintai])
  #   end
  # end

  # describe "GET #show" do
  #   it "assigns the requested kintai as @kintai" do
  #     kintai = Kintai.create! valid_attributes
  #     get :show,params: {:id => kintai.to_param},session: valid_session
  #     expect(assigns(:kintai)).to eq(kintai)
  #   end
  # end

  # describe "GET #new" do
  #   it "assigns a new kintai as @kintai" do
  #     get :new,session: valid_session
  #     expect(assigns(:kintai)).to be_a_new(Kintai)
  #   end
  # end

  # describe "GET #edit" do
  #   it "assigns the requested kintai as @kintai" do
  #     kintai = Kintai.create! valid_attributes
  #     get :edit,params: {:id => kintai.to_param},session: valid_session
  #     expect(assigns(:kintai)).to eq(kintai)
  #   end
  # end

  # describe "POST #create" do
  #   context "with valid params" do
  #     it "creates a new Kintai" do
  #       expect {
  #         post :create, {:kintai => valid_attributes},session: valid_session
  #       }.to change(Kintai, :count).by(1)
  #     end

  #     it "assigns a newly created kintai as @kintai" do
  #       post :create, {:kintai => valid_attributes},session: valid_session
  #       expect(assigns(:kintai)).to be_a(Kintai)
  #       expect(assigns(:kintai)).to be_persisted
  #     end

  #     it "redirects to the created kintai" do
  #       post :create, {:kintai => valid_attributes},session: valid_session
  #       expect(response).to redirect_to(Kintai.last)
  #     end
  #   end

  #   context "with invalid params" do
  #     it "assigns a newly created but unsaved kintai as @kintai" do
  #       post :create, {:kintai => invalid_attributes},session: valid_session
  #       expect(assigns(:kintai)).to be_a_new(Kintai)
  #     end

  #     it "re-renders the 'new' template" do
  #       post :create, {:kintai => invalid_attributes},session: valid_session
  #       expect(response).to render_template("new")
  #     end
  #   end
  # end

  # describe "PUT #update" do
  #   context "with valid params" do
  #     let(:new_attributes) {
  #       skip("Add a hash of attributes valid for your model")
  #     }

  #     it "updates the requested kintai" do
  #       kintai = Kintai.create! valid_attributes
  #       put :update,params: {:id => kintai.to_param, :kintai => new_attributes},session: valid_session
  #       kintai.reload
  #       skip("Add assertions for updated state")
  #     end

  #     it "assigns the requested kintai as @kintai" do
  #       kintai = Kintai.create! valid_attributes
  #       put :update,params: {:id => kintai.to_param, :kintai => valid_attributes},session: valid_session
  #       expect(assigns(:kintai)).to eq(kintai)
  #     end

  #     it "redirects to the kintai" do
  #       kintai = Kintai.create! valid_attributes
  #       put :update,params: {:id => kintai.to_param, :kintai => valid_attributes},session: valid_session
  #       expect(response).to redirect_to(kintai)
  #     end
  #   end

  #   context "with invalid params" do
  #     it "assigns the kintai as @kintai" do
  #       kintai = Kintai.create! valid_attributes
  #       put :update,params: {:id => kintai.to_param, :kintai => invalid_attributes},session: valid_session
  #       expect(assigns(:kintai)).to eq(kintai)
  #     end

  #     it "re-renders the 'edit' template" do
  #       kintai = Kintai.create! valid_attributes
  #       put :update,params: {:id => kintai.to_param, :kintai => invalid_attributes},session: valid_session
  #       expect(response).to render_template("edit")
  #     end
  #   end
  # end

  # describe "DELETE #destroy" do
  #   it "destroys the requested kintai" do
  #     kintai = Kintai.create! valid_attributes
  #     expect {
  #       delete :destroy,params: {:id => kintai.to_param},session: valid_session
  #     }.to change(Kintai, :count).by(-1)
  #   end

  #   it "redirects to the kintais list" do
  #     kintai = Kintai.create! valid_attributes
  #     delete :destroy,params: {:id => kintai.to_param},session: valid_session
  #     expect(response).to redirect_to(kintais_url)
  #   end
  # end

end
