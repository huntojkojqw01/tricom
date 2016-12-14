require 'rails_helper'

RSpec.describe "keihis/index", type: :view do
  before(:each) do
    assign(:keihiheads, [
      Keihi.create!(
        :first_name => "First Name"
      ),
      Keihi.create!(
        :first_name => "First Name"
      )
    ])
  end

  it "renders a list of keihis" do
    render
    assert_select "tr>td", :text => "First Name".to_s, :count => 2
  end
end
