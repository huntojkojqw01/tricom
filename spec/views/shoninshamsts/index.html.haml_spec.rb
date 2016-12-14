require 'rails_helper'

RSpec.describe "shoninshamsts/index", type: :view do
  before(:each) do
    assign(:shoninshamsts, [
      Shoninshamst.create!(
        :first_name => "First Name",
        :last_name => "Last Name"
      ),
      Shoninshamst.create!(
        :first_name => "First Name",
        :last_name => "Last Name"
      )
    ])
  end

  it "renders a list of shoninshamsts" do
    render
    assert_select "tr>td", :text => "First Name".to_s, :count => 2
    assert_select "tr>td", :text => "Last Name".to_s, :count => 2
  end
end
