require 'rails_helper'

RSpec.describe "dengons/new", type: :view do
  before(:each) do
    assign(:dengon, Dengon.new(
      :first_name => "MyString",
      :last_name => "MyString"
    ))
  end

  it "renders new dengon form" do
    render

    assert_select "form[action=?][method=?]", dengons_path, "post" do

      assert_select "input#dengon_first_name[name=?]", "dengon[first_name]"

      assert_select "input#dengon_last_name[name=?]", "dengon[last_name]"
    end
  end
end
