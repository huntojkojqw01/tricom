require 'rails_helper'

RSpec.describe "shoninshamsts/new", type: :view do
  before(:each) do
    assign(:shoninshamst, Shoninshamst.new(
      :first_name => "MyString",
      :last_name => "MyString"
    ))
  end

  it "renders new shoninshamst form" do
    render

    assert_select "form[action=?][method=?]", shoninshamsts_path, "post" do

      assert_select "input#shoninshamst_first_name[name=?]", "shoninshamst[first_name]"

      assert_select "input#shoninshamst_last_name[name=?]", "shoninshamst[last_name]"
    end
  end
end
