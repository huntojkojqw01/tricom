require 'rails_helper'

RSpec.describe "jobmasters/index", type: :view do
  before(:each) do
    assign(:jobmasters, [
      Jobmaster.create!(
        :jobbango => "Jobbango",
        :jobname => "Jobname",
        :userbango => "Userbango",
        :username => "Username"
      ),
      Jobmaster.create!(
        :jobbango => "Jobbango",
        :jobname => "Jobname",
        :userbango => "Userbango",
        :username => "Username"
      )
    ])
  end

  it "renders a list of jobmasters" do
    render
    assert_select "tr>td", :text => "Jobbango".to_s, :count => 2
    assert_select "tr>td", :text => "Jobname".to_s, :count => 2
    assert_select "tr>td", :text => "Userbango".to_s, :count => 2
    assert_select "tr>td", :text => "Username".to_s, :count => 2
  end
end
