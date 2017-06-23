require 'rails_helper'



RSpec.describe ShoninshamstsController, type: :controller do
  fixtures :users
  # This should return the minimal set of attributes required to create a valid
  # Shoninshamst. As you add validations to Shoninshamst, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # ShoninshamstsController. Be sure to keep this updated too.
  let(:valid_session) { {current_user_id: User.first.id} }

  # describe "GET #index" do
  #   it "assigns all shoninshamsts as @shoninshamsts" do
  #     shoninshamst = Shoninshamst.create! valid_attributes
  #     get :index,session: valid_session
  #     expect(assigns(:shoninshamsts)).to eq([shoninshamst])
  #   end
  # end

  # describe "GET #show" do
  #   it "assigns the requested shoninshamst as @shoninshamst" do
  #     shoninshamst = Shoninshamst.create! valid_attributes
  #     get :show,params: {:id => shoninshamst.to_param},session: valid_session
  #     expect(assigns(:shoninshamst)).to eq(shoninshamst)
  #   end
  # end

  # describe "GET #new" do
  #   it "assigns a new shoninshamst as @shoninshamst" do
  #     get :new,session: valid_session
  #     expect(assigns(:shoninshamst)).to be_a_new(Shoninshamst)
  #   end
  # end

  # describe "GET #edit" do
  #   it "assigns the requested shoninshamst as @shoninshamst" do
  #     shoninshamst = Shoninshamst.create! valid_attributes
  #     get :edit,params: {:id => shoninshamst.to_param},session: valid_session
  #     expect(assigns(:shoninshamst)).to eq(shoninshamst)
  #   end
  # end

  # describe "POST #create" do
  #   context "with valid params" do
  #     it "creates a new Shoninshamst" do
  #       expect {
  #         post :create, {:shoninshamst => valid_attributes},session: valid_session
  #       }.to change(Shoninshamst, :count).by(1)
  #     end

  #     it "assigns a newly created shoninshamst as @shoninshamst" do
  #       post :create, {:shoninshamst => valid_attributes},session: valid_session
  #       expect(assigns(:shoninshamst)).to be_a(Shoninshamst)
  #       expect(assigns(:shoninshamst)).to be_persisted
  #     end

  #     it "redirects to the created shoninshamst" do
  #       post :create, {:shoninshamst => valid_attributes},session: valid_session
  #       expect(response).to redirect_to(Shoninshamst.last)
  #     end
  #   end

  #   context "with invalid params" do
  #     it "assigns a newly created but unsaved shoninshamst as @shoninshamst" do
  #       post :create, {:shoninshamst => invalid_attributes},session: valid_session
  #       expect(assigns(:shoninshamst)).to be_a_new(Shoninshamst)
  #     end

  #     it "re-renders the 'new' template" do
  #       post :create, {:shoninshamst => invalid_attributes},session: valid_session
  #       expect(response).to render_template("new")
  #     end
  #   end
  # end

  # describe "PUT #update" do
  #   context "with valid params" do
  #     let(:new_attributes) {
  #       skip("Add a hash of attributes valid for your model")
  #     }

  #     it "updates the requested shoninshamst" do
  #       shoninshamst = Shoninshamst.create! valid_attributes
  #       put :update,params: {:id => shoninshamst.to_param, :shoninshamst => new_attributes},session: valid_session
  #       shoninshamst.reload
  #       skip("Add assertions for updated state")
  #     end

  #     it "assigns the requested shoninshamst as @shoninshamst" do
  #       shoninshamst = Shoninshamst.create! valid_attributes
  #       put :update,params: {:id => shoninshamst.to_param, :shoninshamst => valid_attributes},session: valid_session
  #       expect(assigns(:shoninshamst)).to eq(shoninshamst)
  #     end

  #     it "redirects to the shoninshamst" do
  #       shoninshamst = Shoninshamst.create! valid_attributes
  #       put :update,params: {:id => shoninshamst.to_param, :shoninshamst => valid_attributes},session: valid_session
  #       expect(response).to redirect_to(shoninshamst)
  #     end
  #   end

  #   context "with invalid params" do
  #     it "assigns the shoninshamst as @shoninshamst" do
  #       shoninshamst = Shoninshamst.create! valid_attributes
  #       put :update,params: {:id => shoninshamst.to_param, :shoninshamst => invalid_attributes},session: valid_session
  #       expect(assigns(:shoninshamst)).to eq(shoninshamst)
  #     end

  #     it "re-renders the 'edit' template" do
  #       shoninshamst = Shoninshamst.create! valid_attributes
  #       put :update,params: {:id => shoninshamst.to_param, :shoninshamst => invalid_attributes},session: valid_session
  #       expect(response).to render_template("edit")
  #     end
  #   end
  # end

  # describe "DELETE #destroy" do
  #   it "destroys the requested shoninshamst" do
  #     shoninshamst = Shoninshamst.create! valid_attributes
  #     expect {
  #       delete :destroy,params: {:id => shoninshamst.to_param},session: valid_session
  #     }.to change(Shoninshamst, :count).by(-1)
  #   end

  #   it "redirects to the shoninshamsts list" do
  #     shoninshamst = Shoninshamst.create! valid_attributes
  #     delete :destroy,params: {:id => shoninshamst.to_param},session: valid_session
  #     expect(response).to redirect_to(shoninshamsts_url)
  #   end
  # end

end
