require 'rails_helper'

RSpec.describe "shozais/index", type: :view do
  before(:each) do
    assign(:shozais, [
      Shozai.create!(
        :shozai_code => "Shozai Code",
        :shozai_name => "Shozai Name"
      ),
      Shozai.create!(
        :shozai_code => "Shozai Code",
        :shozai_name => "Shozai Name"
      )
    ])
  end

  it "renders a list of shozais" do
    render
    assert_select "tr>td", :text => "Shozai Code".to_s, :count => 2
    assert_select "tr>td", :text => "Shozai Name".to_s, :count => 2
  end
end
