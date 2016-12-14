require 'rails_helper'

RSpec.describe "kaishamasters/new", type: :view do
  before(:each) do
    assign(:kaishamaster, Kaishamaster.new(
      :first_name => "MyString",
      :last_name => "MyString"
    ))
  end

  it "renders new kaishamaster form" do
    render

    assert_select "form[action=?][method=?]", kaishamasters_path, "post" do

      assert_select "input#kaishamaster_first_name[name=?]", "kaishamaster[first_name]"

      assert_select "input#kaishamaster_last_name[name=?]", "kaishamaster[last_name]"
    end
  end
end
