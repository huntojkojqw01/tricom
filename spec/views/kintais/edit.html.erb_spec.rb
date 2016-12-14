require 'rails_helper'

RSpec.describe "kintais/edit", type: :view do
  before(:each) do
    @kintai = assign(:kintai, Kintai.create!(
      :first_name => "MyString",
      :last_name => "MyString"
    ))
  end

  it "renders the edit kintai form" do
    render

    assert_select "form[action=?][method=?]", kintai_path(@kintai), "post" do

      assert_select "input#kintai_first_name[name=?]", "kintai[first_name]"

      assert_select "input#kintai_last_name[name=?]", "kintai[last_name]"
    end
  end
end
