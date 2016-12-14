require 'rails_helper'

RSpec.describe "dengonkaitous/edit", type: :view do
  before(:each) do
    @dengonkaitou = assign(:dengonkaitou, Dengonkaitou.create!(
      :first_name => "MyString",
      :last_name => "MyString"
    ))
  end

  it "renders the edit dengonkaitou form" do
    render

    assert_select "form[action=?][method=?]", dengonkaitou_path(@dengonkaitou), "post" do

      assert_select "input#dengonkaitou_first_name[name=?]", "dengonkaitou[first_name]"

      assert_select "input#dengonkaitou_last_name[name=?]", "dengonkaitou[last_name]"
    end
  end
end
