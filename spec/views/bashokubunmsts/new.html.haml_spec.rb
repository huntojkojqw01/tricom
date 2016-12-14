require 'rails_helper'

RSpec.describe "bashokubunmsts/new", type: :view do
  before(:each) do
    assign(:bashokubunmst, Bashokubunmst.new(
      :first_name => "MyString",
      :last_name => "MyString"
    ))
  end

  it "renders new bashokubunmst form" do
    render

    assert_select "form[action=?][method=?]", bashokubunmsts_path, "post" do

      assert_select "input#bashokubunmst_first_name[name=?]", "bashokubunmst[first_name]"

      assert_select "input#bashokubunmst_last_name[name=?]", "bashokubunmst[last_name]"
    end
  end
end
