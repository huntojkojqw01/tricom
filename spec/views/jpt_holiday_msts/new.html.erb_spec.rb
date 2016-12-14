require 'rails_helper'

RSpec.describe "jpt_holiday_msts/new", type: :view do
  before(:each) do
    assign(:jpt_holiday_mst, JptHolidayMst.new(
      :event_date => "MyString",
      :date, => "MyString",
      :title => "MyString",
      :string, => "MyString",
      :description => "MyString",
      :text => "MyString"
    ))
  end

  it "renders new jpt_holiday_mst form" do
    render

    assert_select "form[action=?][method=?]", jpt_holiday_msts_path, "post" do

      assert_select "input#jpt_holiday_mst_event_date[name=?]", "jpt_holiday_mst[event_date]"

      assert_select "input#jpt_holiday_mst_date,[name=?]", "jpt_holiday_mst[date,]"

      assert_select "input#jpt_holiday_mst_title[name=?]", "jpt_holiday_mst[title]"

      assert_select "input#jpt_holiday_mst_string,[name=?]", "jpt_holiday_mst[string,]"

      assert_select "input#jpt_holiday_mst_description[name=?]", "jpt_holiday_mst[description]"

      assert_select "input#jpt_holiday_mst_text[name=?]", "jpt_holiday_mst[text]"
    end
  end
end
