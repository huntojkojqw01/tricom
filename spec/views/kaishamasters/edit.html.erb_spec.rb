require 'rails_helper'

RSpec.describe "kaishamasters/edit", type: :view do
  before(:each) do
    @kaishamaster = assign(:kaishamaster, Kaishamaster.create!(
      :first_name => "MyString",
      :last_name => "MyString"
    ))
  end

  it "renders the edit kaishamaster form" do
    render

    assert_select "form[action=?][method=?]", kaishamaster_path(@kaishamaster), "post" do

      assert_select "input#kaishamaster_first_name[name=?]", "kaishamaster[first_name]"

      assert_select "input#kaishamaster_last_name[name=?]", "kaishamaster[last_name]"
    end
  end
end
