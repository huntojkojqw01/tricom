require 'rails_helper'

RSpec.describe "tsushinseigyous/index", type: :view do
  before(:each) do
    assign(:tsushinseigyous, [
      Tsushinseigyou.create!(
        :first_name => "First Name",
        :last_name => "Last Name"
      ),
      Tsushinseigyou.create!(
        :first_name => "First Name",
        :last_name => "Last Name"
      )
    ])
  end

  it "renders a list of tsushinseigyous" do
    render
    assert_select "tr>td", :text => "First Name".to_s, :count => 2
    assert_select "tr>td", :text => "Last Name".to_s, :count => 2
  end
end
