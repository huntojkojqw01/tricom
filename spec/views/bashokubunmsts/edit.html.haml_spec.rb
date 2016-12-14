require 'rails_helper'

RSpec.describe "bashokubunmsts/edit", type: :view do
  before(:each) do
    @bashokubunmst = assign(:bashokubunmst, Bashokubunmst.create!(
      :first_name => "MyString",
      :last_name => "MyString"
    ))
  end

  it "renders the edit bashokubunmst form" do
    render

    assert_select "form[action=?][method=?]", bashokubunmst_path(@bashokubunmst), "post" do

      assert_select "input#bashokubunmst_first_name[name=?]", "bashokubunmst[first_name]"

      assert_select "input#bashokubunmst_last_name[name=?]", "bashokubunmst[last_name]"
    end
  end
end
