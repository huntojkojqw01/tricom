require 'rails_helper'

RSpec.describe "jobmasters/new", type: :view do
  before(:each) do
    assign(:jobmaster, Jobmaster.new(
      :jobbango => "MyString",
      :jobname => "MyString",
      :userbango => "MyString",
      :username => "MyString"
    ))
  end

  it "renders new jobmaster form" do
    render

    assert_select "form[action=?][method=?]", jobmasters_path, "post" do

      assert_select "input#jobmaster_jobbango[name=?]", "jobmaster[jobbango]"

      assert_select "input#jobmaster_jobname[name=?]", "jobmaster[jobname]"

      assert_select "input#jobmaster_userbango[name=?]", "jobmaster[userbango]"

      assert_select "input#jobmaster_username[name=?]", "jobmaster[username]"
    end
  end
end
