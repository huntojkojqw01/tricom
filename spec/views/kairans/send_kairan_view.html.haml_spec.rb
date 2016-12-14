require 'rails_helper'

RSpec.describe "kairans/edit", type: :view do
  before(:each) do
    @kairan = assign(:kairan, Kairan.create!(
      :hakkousha => "MyString",
      :namelist => "MyString"
    ))
  end

  it "renders the edit kairan form" do
    render

    assert_select "form[action=?][method=?]", kairan_path(@kairan), "post" do

      assert_select "input#kairan_hakkousha[name=?]", "kairan[hakkousha]"

      assert_select "input#kairan_namelist[name=?]", "kairan[namelist]"
    end
  end
end
