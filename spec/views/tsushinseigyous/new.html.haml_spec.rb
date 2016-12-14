require 'rails_helper'

RSpec.describe "tsushinseigyous/new", type: :view do
  before(:each) do
    assign(:tsushinseigyou, Tsushinseigyou.new(
      :first_name => "MyString",
      :last_name => "MyString"
    ))
  end

  it "renders new tsushinseigyou form" do
    render

    assert_select "form[action=?][method=?]", tsushinseigyous_path, "post" do

      assert_select "input#tsushinseigyou_first_name[name=?]", "tsushinseigyou[first_name]"

      assert_select "input#tsushinseigyou_last_name[name=?]", "tsushinseigyou[last_name]"
    end
  end
end
