require 'rails_helper'

RSpec.describe "shozais/edit", type: :view do
  before(:each) do
    @shozai = assign(:shozai, Shozai.create!(
      :shozai_code => "MyString",
      :shozai_name => "MyString"
    ))
  end

  it "renders the edit shozai form" do
    render

    assert_select "form[action=?][method=?]", shozai_path(@shozai), "post" do

      assert_select "input#shozai_shozai_code[name=?]", "shozai[shozai_code]"

      assert_select "input#shozai_shozai_name[name=?]", "shozai[shozai_name]"
    end
  end
end
