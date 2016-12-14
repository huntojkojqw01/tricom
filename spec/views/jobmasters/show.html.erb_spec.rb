require 'rails_helper'

RSpec.describe "jobmasters/show", type: :view do
  before(:each) do
    @jobmaster = assign(:jobmaster, Jobmaster.create!(
      :jobbango => "Jobbango",
      :jobname => "Jobname",
      :userbango => "Userbango",
      :username => "Username"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Jobbango/)
    expect(rendered).to match(/Jobname/)
    expect(rendered).to match(/Userbango/)
    expect(rendered).to match(/Username/)
  end
end
