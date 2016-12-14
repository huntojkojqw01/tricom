require 'rails_helper'

RSpec.describe "dengons/edit", type: :view do
  before(:each) do
    @dengon = assign(:dengon, Dengon.create!(
      :first_name => "MyString",
      :last_name => "MyString"
    ))
  end

  it "renders the edit dengon form" do
    render

    assert_select "form[action=?][method=?]", dengon_path(@dengon), "post" do

      assert_select "input#dengon_first_name[name=?]", "dengon[first_name]"

      assert_select "input#dengon_last_name[name=?]", "dengon[last_name]"
    end
  end
end
