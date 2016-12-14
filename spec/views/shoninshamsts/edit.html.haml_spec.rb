require 'rails_helper'

RSpec.describe "shoninshamsts/edit", type: :view do
  before(:each) do
    @shoninshamst = assign(:shoninshamst, Shoninshamst.create!(
      :first_name => "MyString",
      :last_name => "MyString"
    ))
  end

  it "renders the edit shoninshamst form" do
    render

    assert_select "form[action=?][method=?]", shoninshamst_path(@shoninshamst), "post" do

      assert_select "input#shoninshamst_first_name[name=?]", "shoninshamst[first_name]"

      assert_select "input#shoninshamst_last_name[name=?]", "shoninshamst[last_name]"
    end
  end
end
