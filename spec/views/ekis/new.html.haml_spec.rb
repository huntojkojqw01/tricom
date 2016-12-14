require 'rails_helper'

RSpec.describe "ekis/new", type: :view do
  before(:each) do
    assign(:eki, Eki.new(
      :first_name => "MyString",
      :last_name => "MyString"
    ))
  end

  it "renders new eki form" do
    render

    assert_select "form[action=?][method=?]", ekis_path, "post" do

      assert_select "input#eki_first_name[name=?]", "eki[first_name]"

      assert_select "input#eki_last_name[name=?]", "eki[last_name]"
    end
  end
end
