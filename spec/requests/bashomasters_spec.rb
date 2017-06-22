require 'rails_helper'
include SessionsHelper
RSpec.describe "Bashomasters management", type: :request do
  let(:valid_attributes) {
    {場所コード: 1122334455,
      場所名: "test 場所名",
      場所名カナ: "test 場所名カナ",
      SUB: "test",場所区分: '1',
      会社コード: "90000"}
  }

  let(:invalid_attributes) {
    {場所コード: 1122334455,
      場所名: nil,
      場所名カナ: "test 場所名カナ",
      SUB: "test",場所区分: '1',
      会社コード: "90000"}
  }
  let(:new_attributes) {
    {場所コード: 1122334455,
      場所名: "test 場所名 updated",
      場所名カナ: "test 場所名カナ updated",
      SUB: "test updated",場所区分: '2',
      会社コード: "90000"}
  }
  fixtures :bashomasters, :users
  before :each do
    @user= User.find(10029)
    post login_path, {:session => {担当者コード: @user.id, password: 10029}}
  end

  it "list all Bashomasters!" do
    get bashomasters_path
    expect(response).to render_template("index")
  end

  it "creates a Bashomaster and redirects to the Bashomaster's page" do
    get "/bashomasters/new"
    expect(response).to render_template(:new)

    post "/bashomasters", {:bashomaster => valid_attributes}

    expect(response).to redirect_to(assigns(:bashomaster))
    follow_redirect!

    expect(response).to render_template(:show)
  end

  it "does not render a different template" do
    get "/bashomasters/new"
    expect(response).to_not render_template(:show)
  end

  it "updates a Bashomaster and redirects to the Bashomaster's page" do

    bashomaster = Bashomaster.create! valid_attributes
    get edit_bashomaster_path(bashomaster)
    expect(response).to render_template(:edit)

    put bashomaster_path(bashomaster), {:bashomaster => new_attributes}

    expect(response).to redirect_to(assigns(:bashomaster))
    follow_redirect!

    expect(response).to render_template(:show)
  end

  it "deletes a Bashomaster and redirects to the bashomasters list" do

    bashomaster = Bashomaster.create! valid_attributes
    delete bashomaster_path(bashomaster)
    expect(response).to redirect_to(:action => :index)
    follow_redirect!
    expect(response).to render_template(:index)
  end


end
