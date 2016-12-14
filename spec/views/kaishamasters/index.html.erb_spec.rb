require 'rails_helper'

RSpec.describe "kaishamasters/index", type: :view do
  before(:each) do
    assign(:kaishamasters, [
      Kaishamaster.create!(
        :first_name => "First Name",
        :last_name => "Last Name"
      ),
      Kaishamaster.create!(
        :first_name => "First Name",
        :last_name => "Last Name"
      )
    ])
  end

  it "renders a list of kaishamasters" do
    render
    assert_select "tr>td", :text => "First Name".to_s, :count => 2
    assert_select "tr>td", :text => "Last Name".to_s, :count => 2
  end
end
