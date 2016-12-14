require 'rails_helper'

RSpec.describe "keihis/edit", type: :view do
  before(:each) do
    @keihi = assign(:keihi, Keihi.create!(
      :first_name => "MyString"
    ))
  end

  it "renders the edit keihi form" do
    render

    assert_select "form[action=?][method=?]", keihi_path(@keihi), "post" do

      assert_select "input#keihi_first_name[name=?]", "keihi[first_name]"
    end
  end
end
