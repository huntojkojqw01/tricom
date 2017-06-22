require 'rails_helper'



RSpec.describe ShozaisController, type: :controller do
  fixtures :users
  # This should return the minimal set of attributes required to create a valid
  # Shozai. As you add validations to Shozai, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # ShozaisController. Be sure to keep this updated too.
  let(:valid_session) { {current_user_id: User.first.id} }

  # describe "GET #index" do
  #   it "assigns all shozais as @shozais" do
  #     shozai = Shozai.create! valid_attributes
  #     get :index,session: valid_session
  #     expect(assigns(:shozais)).to eq([shozai])
  #   end
  # end

  # describe "GET #show" do
  #   it "assigns the requested shozai as @shozai" do
  #     shozai = Shozai.create! valid_attributes
  #     get :show,params: {:id => shozai.to_param},session: valid_session
  #     expect(assigns(:shozai)).to eq(shozai)
  #   end
  # end

  # describe "GET #new" do
  #   it "assigns a new shozai as @shozai" do
  #     get :new,session: valid_session
  #     expect(assigns(:shozai)).to be_a_new(Shozai)
  #   end
  # end

  # describe "GET #edit" do
  #   it "assigns the requested shozai as @shozai" do
  #     shozai = Shozai.create! valid_attributes
  #     get :edit,params: {:id => shozai.to_param},session: valid_session
  #     expect(assigns(:shozai)).to eq(shozai)
  #   end
  # end

  # describe "POST #create" do
  #   context "with valid params" do
  #     it "creates a new Shozai" do
  #       expect {
  #         post :create, {:shozai => valid_attributes},session: valid_session
  #       }.to change(Shozai, :count).by(1)
  #     end

  #     it "assigns a newly created shozai as @shozai" do
  #       post :create, {:shozai => valid_attributes},session: valid_session
  #       expect(assigns(:shozai)).to be_a(Shozai)
  #       expect(assigns(:shozai)).to be_persisted
  #     end

  #     it "redirects to the created shozai" do
  #       post :create, {:shozai => valid_attributes},session: valid_session
  #       expect(response).to redirect_to(Shozai.last)
  #     end
  #   end

  #   context "with invalid params" do
  #     it "assigns a newly created but unsaved shozai as @shozai" do
  #       post :create, {:shozai => invalid_attributes},session: valid_session
  #       expect(assigns(:shozai)).to be_a_new(Shozai)
  #     end

  #     it "re-renders the 'new' template" do
  #       post :create, {:shozai => invalid_attributes},session: valid_session
  #       expect(response).to render_template("new")
  #     end
  #   end
  # end

  # describe "PUT #update" do
  #   context "with valid params" do
  #     let(:new_attributes) {
  #       skip("Add a hash of attributes valid for your model")
  #     }

  #     it "updates the requested shozai" do
  #       shozai = Shozai.create! valid_attributes
  #       put :update,params: {:id => shozai.to_param, :shozai => new_attributes},session: valid_session
  #       shozai.reload
  #       skip("Add assertions for updated state")
  #     end

  #     it "assigns the requested shozai as @shozai" do
  #       shozai = Shozai.create! valid_attributes
  #       put :update,params: {:id => shozai.to_param, :shozai => valid_attributes},session: valid_session
  #       expect(assigns(:shozai)).to eq(shozai)
  #     end

  #     it "redirects to the shozai" do
  #       shozai = Shozai.create! valid_attributes
  #       put :update,params: {:id => shozai.to_param, :shozai => valid_attributes},session: valid_session
  #       expect(response).to redirect_to(shozai)
  #     end
  #   end

  #   context "with invalid params" do
  #     it "assigns the shozai as @shozai" do
  #       shozai = Shozai.create! valid_attributes
  #       put :update,params: {:id => shozai.to_param, :shozai => invalid_attributes},session: valid_session
  #       expect(assigns(:shozai)).to eq(shozai)
  #     end

  #     it "re-renders the 'edit' template" do
  #       shozai = Shozai.create! valid_attributes
  #       put :update,params: {:id => shozai.to_param, :shozai => invalid_attributes},session: valid_session
  #       expect(response).to render_template("edit")
  #     end
  #   end
  # end

  # describe "DELETE #destroy" do
  #   it "destroys the requested shozai" do
  #     shozai = Shozai.create! valid_attributes
  #     expect {
  #       delete :destroy,params: {:id => shozai.to_param},session: valid_session
  #     }.to change(Shozai, :count).by(-1)
  #   end

  #   it "redirects to the shozais list" do
  #     shozai = Shozai.create! valid_attributes
  #     delete :destroy,params: {:id => shozai.to_param},session: valid_session
  #     expect(response).to redirect_to(shozais_url)
  #   end
  # end

end
