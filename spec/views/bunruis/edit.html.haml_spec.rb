require 'rails_helper'

RSpec.describe "bunruis/edit", type: :view do
  before(:each) do
    @bunrui = assign(:bunrui, Bunrui.create!(
      :first_name => "MyString",
      :last_name => "MyString"
    ))
  end

  it "renders the edit bunrui form" do
    render

    assert_select "form[action=?][method=?]", bunrui_path(@bunrui), "post" do

      assert_select "input#bunrui_first_name[name=?]", "bunrui[first_name]"

      assert_select "input#bunrui_last_name[name=?]", "bunrui[last_name]"
    end
  end
end
