require 'rails_helper'

RSpec.describe "kairanyokenmsts/edit", type: :view do
  before(:each) do
    @kairanyokenmst = assign(:kairanyokenmst, Kairanyokenmst.create!(
      :first_name => "MyString",
      :last_name => "MyString"
    ))
  end

  it "renders the edit kairanyokenmst form" do
    render

    assert_select "form[action=?][method=?]", kairanyokenmst_path(@kairanyokenmst), "post" do

      assert_select "input#kairanyokenmst_first_name[name=?]", "kairanyokenmst[first_name]"

      assert_select "input#kairanyokenmst_last_name[name=?]", "kairanyokenmst[last_name]"
    end
  end
end
