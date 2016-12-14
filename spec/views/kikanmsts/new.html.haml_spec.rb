require 'rails_helper'

RSpec.describe "kikanmsts/new", type: :view do
  before(:each) do
    assign(:kikanmst, Kikanmst.new(
      :first_name => "MyString",
      :last_name => "MyString"
    ))
  end

  it "renders new kikanmst form" do
    render

    assert_select "form[action=?][method=?]", kikanmsts_path, "post" do

      assert_select "input#kikanmst_first_name[name=?]", "kikanmst[first_name]"

      assert_select "input#kikanmst_last_name[name=?]", "kikanmst[last_name]"
    end
  end
end
