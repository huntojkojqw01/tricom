require 'rails_helper'

RSpec.describe "jobmasters/edit", type: :view do
  before(:each) do
    @jobmaster = assign(:jobmaster, Jobmaster.create!(
      :jobbango => "MyString",
      :jobname => "MyString",
      :userbango => "MyString",
      :username => "MyString"
    ))
  end

  it "renders the edit jobmaster form" do
    render

    assert_select "form[action=?][method=?]", jobmaster_path(@jobmaster), "post" do

      assert_select "input#jobmaster_jobbango[name=?]", "jobmaster[jobbango]"

      assert_select "input#jobmaster_jobname[name=?]", "jobmaster[jobname]"

      assert_select "input#jobmaster_userbango[name=?]", "jobmaster[userbango]"

      assert_select "input#jobmaster_username[name=?]", "jobmaster[username]"
    end
  end
end
