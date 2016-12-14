require 'rails_helper'

RSpec.describe "kairans/new", type: :view do
  before(:each) do
    assign(:kairan, Kairan.new(
      :hakkousha => "MyString",
      :namelist => "MyString"
    ))
  end

  it "renders new kairan form" do
    render

    assert_select "form[action=?][method=?]", kairans_path, "post" do

      assert_select "input#kairan_hakkousha[name=?]", "kairan[hakkousha]"

      assert_select "input#kairan_namelist[name=?]", "kairan[namelist]"
    end
  end
end
