require 'rails_helper'

RSpec.describe "dengonyoukens/edit", type: :view do
  before(:each) do
    @dengonyouken = assign(:dengonyouken, Dengonyouken.create!(
      :first_name => "MyString",
      :last_name => "MyString"
    ))
  end

  it "renders the edit dengonyouken form" do
    render

    assert_select "form[action=?][method=?]", dengonyouken_path(@dengonyouken), "post" do

      assert_select "input#dengonyouken_first_name[name=?]", "dengonyouken[first_name]"

      assert_select "input#dengonyouken_last_name[name=?]", "dengonyouken[last_name]"
    end
  end
end
