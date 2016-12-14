require 'rails_helper'

RSpec.describe "bunruis/new", type: :view do
  before(:each) do
    assign(:bunrui, Bunrui.new(
      :first_name => "MyString",
      :last_name => "MyString"
    ))
  end

  it "renders new bunrui form" do
    render

    assert_select "form[action=?][method=?]", bunruis_path, "post" do

      assert_select "input#bunrui_first_name[name=?]", "bunrui[first_name]"

      assert_select "input#bunrui_last_name[name=?]", "bunrui[last_name]"
    end
  end
end
