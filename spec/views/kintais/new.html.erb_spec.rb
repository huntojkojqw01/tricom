require 'rails_helper'

RSpec.describe "kintais/new", type: :view do
  before(:each) do
    assign(:kintai, Kintai.new(
      :first_name => "MyString",
      :last_name => "MyString"
    ))
  end

  it "renders new kintai form" do
    render

    assert_select "form[action=?][method=?]", kintais_path, "post" do

      assert_select "input#kintai_first_name[name=?]", "kintai[first_name]"

      assert_select "input#kintai_last_name[name=?]", "kintai[last_name]"
    end
  end
end
