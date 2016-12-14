require 'rails_helper'

RSpec.describe "shozais/new", type: :view do
  before(:each) do
    assign(:shozai, Shozai.new(
      :shozai_code => "MyString",
      :shozai_name => "MyString"
    ))
  end

  it "renders new shozai form" do
    render

    assert_select "form[action=?][method=?]", shozais_path, "post" do

      assert_select "input#shozai_shozai_code[name=?]", "shozai[shozai_code]"

      assert_select "input#shozai_shozai_name[name=?]", "shozai[shozai_name]"
    end
  end
end
