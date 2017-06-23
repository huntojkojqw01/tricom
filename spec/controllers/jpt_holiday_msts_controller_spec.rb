require 'rails_helper'

RSpec.describe JptHolidayMstsController, type: :controller do
  fixtures :users
  # This should return the minimal set of attributes required to create a valid
  # JptHolidayMst. As you add validations to JptHolidayMst, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    {event_date: "2015-08-13", title: "Jpt Holiday", description: "Jpt Holiday all day"}
  }

  let(:invalid_attributes) {
    {event_date: "", title: "Jpt Holiday", description: "Jpt Holiday all day"}
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # JptHolidayMstsController. Be sure to keep this updated too.
  let(:valid_session) { {current_user_id: User.first.id} }

  describe "GET #index" do
    it "assigns all jpt_holiday_msts as @jpt_holiday_msts" do
      jpt_holiday_mst = JptHolidayMst.create! valid_attributes
      get :index,session: valid_session
      expect(assigns(:jpt_holiday_msts)).to eq([jpt_holiday_mst])
    end
  end

  describe "GET #show" do
    it "assigns the requested jpt_holiday_mst as @jpt_holiday_mst" do
      jpt_holiday_mst = JptHolidayMst.create! valid_attributes
      get :show,params: {:id => jpt_holiday_mst.to_param},session: valid_session
      expect(assigns(:jpt_holiday_mst)).to eq(jpt_holiday_mst)
    end
  end

  describe "GET #new" do
    it "assigns a new jpt_holiday_mst as @jpt_holiday_mst" do
      get :new,session: valid_session
      expect(assigns(:jpt_holiday_mst)).to be_a_new(JptHolidayMst)
    end
  end

  describe "GET #edit" do
    it "assigns the requested jpt_holiday_mst as @jpt_holiday_mst" do
      jpt_holiday_mst = JptHolidayMst.create! valid_attributes
      get :edit,params: {:id => jpt_holiday_mst.to_param},session: valid_session
      expect(assigns(:jpt_holiday_mst)).to eq(jpt_holiday_mst)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new JptHolidayMst" do
        expect {
          post :create,params: {:jpt_holiday_mst => valid_attributes},session: valid_session
        }.to change(JptHolidayMst, :count).by(1)
      end

      it "assigns a newly created jpt_holiday_mst as @jpt_holiday_mst" do
        post :create,params: {:jpt_holiday_mst => valid_attributes},session: valid_session
        expect(assigns(:jpt_holiday_mst)).to be_a(JptHolidayMst)
        expect(assigns(:jpt_holiday_mst)).to be_persisted
      end

      it "redirects to the created jpt_holiday_mst" do
        post :create,params: {:jpt_holiday_mst => valid_attributes},session: valid_session
        expect(response).to redirect_to(JptHolidayMst.last)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved jpt_holiday_mst as @jpt_holiday_mst" do
        post :create,params: {:jpt_holiday_mst => invalid_attributes},session: valid_session
        expect(assigns(:jpt_holiday_mst)).to be_a_new(JptHolidayMst)
      end

      it "re-renders the 'new' template" do
        post :create,params: {:jpt_holiday_mst => invalid_attributes},session: valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        {title: "hung"}
      }

      it "updates the requested jpt_holiday_mst" do
        jpt_holiday_mst = JptHolidayMst.create! valid_attributes
        put :update,params: {:id => jpt_holiday_mst.to_param, :jpt_holiday_mst => new_attributes},session: valid_session
        jpt_holiday_mst.reload
        expect(jpt_holiday_mst.title).to eq("hung")
      end

      it "assigns the requested jpt_holiday_mst as @jpt_holiday_mst" do
        jpt_holiday_mst = JptHolidayMst.create! valid_attributes
        put :update,params: {:id => jpt_holiday_mst.to_param, :jpt_holiday_mst => valid_attributes},session: valid_session
        expect(assigns(:jpt_holiday_mst)).to eq(jpt_holiday_mst)
      end

      it "redirects to the jpt_holiday_mst" do
        jpt_holiday_mst = JptHolidayMst.create! valid_attributes
        put :update,params: {:id => jpt_holiday_mst.to_param, :jpt_holiday_mst => valid_attributes},session: valid_session
        expect(response).to redirect_to(jpt_holiday_mst)
      end
    end

    context "with invalid params" do
      it "assigns the jpt_holiday_mst as @jpt_holiday_mst" do
        jpt_holiday_mst = JptHolidayMst.create! valid_attributes
        put :update,params: {:id => jpt_holiday_mst.to_param, :jpt_holiday_mst => invalid_attributes},session: valid_session
        expect(assigns(:jpt_holiday_mst)).to eq(jpt_holiday_mst)
      end

      it "re-renders the 'edit' template" do
        jpt_holiday_mst = JptHolidayMst.create! valid_attributes
        put :update,params: {:id => jpt_holiday_mst.to_param, :jpt_holiday_mst => invalid_attributes},session: valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested jpt_holiday_mst" do
      jpt_holiday_mst = JptHolidayMst.create! valid_attributes
      expect {
        delete :destroy,params: {:id => jpt_holiday_mst.to_param},session: valid_session
      }.to change(JptHolidayMst, :count).by(-1)
    end

    it "redirects to the jpt_holiday_msts list" do
      jpt_holiday_mst = JptHolidayMst.create! valid_attributes
      delete :destroy,params: {:id => jpt_holiday_mst.to_param},session: valid_session
      expect(response).to redirect_to(jpt_holiday_msts_url)
    end
  end

end
