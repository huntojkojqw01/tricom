require 'rails_helper'

RSpec.describe "ekis/edit", type: :view do
  before(:each) do
    @eki = assign(:eki, Eki.create!(
      :first_name => "MyString",
      :last_name => "MyString"
    ))
  end

  it "renders the edit eki form" do
    render

    assert_select "form[action=?][method=?]", eki_path(@eki), "post" do

      assert_select "input#eki_first_name[name=?]", "eki[first_name]"

      assert_select "input#eki_last_name[name=?]", "eki[last_name]"
    end
  end
end
