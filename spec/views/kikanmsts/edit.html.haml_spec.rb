require 'rails_helper'

RSpec.describe "kikanmsts/edit", type: :view do
  before(:each) do
    @kikanmst = assign(:kikanmst, Kikanmst.create!(
      :first_name => "MyString",
      :last_name => "MyString"
    ))
  end

  it "renders the edit kikanmst form" do
    render

    assert_select "form[action=?][method=?]", kikanmst_path(@kikanmst), "post" do

      assert_select "input#kikanmst_first_name[name=?]", "kikanmst[first_name]"

      assert_select "input#kikanmst_last_name[name=?]", "kikanmst[last_name]"
    end
  end
end
