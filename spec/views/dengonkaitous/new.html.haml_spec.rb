require 'rails_helper'

RSpec.describe "dengonkaitous/new", type: :view do
  before(:each) do
    assign(:dengonkaitou, Dengonkaitou.new(
      :first_name => "MyString",
      :last_name => "MyString"
    ))
  end

  it "renders new dengonkaitou form" do
    render

    assert_select "form[action=?][method=?]", dengonkaitous_path, "post" do

      assert_select "input#dengonkaitou_first_name[name=?]", "dengonkaitou[first_name]"

      assert_select "input#dengonkaitou_last_name[name=?]", "dengonkaitou[last_name]"
    end
  end
end
