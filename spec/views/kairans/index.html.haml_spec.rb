require 'rails_helper'

RSpec.describe "kairans/index", type: :view do
  before(:each) do
    assign(:kairans, [
      Kairan.create!(
        :hakkousha => "Hakkousha",
        :namelist => "Namelist"
      ),
      Kairan.create!(
        :hakkousha => "Hakkousha",
        :namelist => "Namelist"
      )
    ])
  end

  it "renders a list of kairans" do
    render
    assert_select "tr>td", :text => "Hakkousha".to_s, :count => 2
    assert_select "tr>td", :text => "Namelist".to_s, :count => 2
  end
end
