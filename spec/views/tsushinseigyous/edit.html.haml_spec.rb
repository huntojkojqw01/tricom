require 'rails_helper'

RSpec.describe "tsushinseigyous/edit", type: :view do
  before(:each) do
    @tsushinseigyou = assign(:tsushinseigyou, Tsushinseigyou.create!(
      :first_name => "MyString",
      :last_name => "MyString"
    ))
  end

  it "renders the edit tsushinseigyou form" do
    render

    assert_select "form[action=?][method=?]", tsushinseigyou_path(@tsushinseigyou), "post" do

      assert_select "input#tsushinseigyou_first_name[name=?]", "tsushinseigyou[first_name]"

      assert_select "input#tsushinseigyou_last_name[name=?]", "tsushinseigyou[last_name]"
    end
  end
end
