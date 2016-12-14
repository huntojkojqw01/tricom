require 'rails_helper'

RSpec.describe "kairanyokenmsts/new", type: :view do
  before(:each) do
    assign(:kairanyokenmst, Kairanyokenmst.new(
      :first_name => "MyString",
      :last_name => "MyString"
    ))
  end

  it "renders new kairanyokenmst form" do
    render

    assert_select "form[action=?][method=?]", kairanyokenmsts_path, "post" do

      assert_select "input#kairanyokenmst_first_name[name=?]", "kairanyokenmst[first_name]"

      assert_select "input#kairanyokenmst_last_name[name=?]", "kairanyokenmst[last_name]"
    end
  end
end
