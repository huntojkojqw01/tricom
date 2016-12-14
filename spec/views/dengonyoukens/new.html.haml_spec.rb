require 'rails_helper'

RSpec.describe "dengonyoukens/new", type: :view do
  before(:each) do
    assign(:dengonyouken, Dengonyouken.new(
      :first_name => "MyString",
      :last_name => "MyString"
    ))
  end

  it "renders new dengonyouken form" do
    render

    assert_select "form[action=?][method=?]", dengonyoukens_path, "post" do

      assert_select "input#dengonyouken_first_name[name=?]", "dengonyouken[first_name]"

      assert_select "input#dengonyouken_last_name[name=?]", "dengonyouken[last_name]"
    end
  end
end
