require 'rails_helper'

RSpec.describe "keihis/new", type: :view do
  before(:each) do
    assign(:keihi, Keihi.new(
      :first_name => "MyString"
    ))
  end

  it "renders new keihi form" do
    render

    assert_select "form[action=?][method=?]", keihis_path, "post" do

      assert_select "input#keihi_first_name[name=?]", "keihi[first_name]"
    end
  end
end
