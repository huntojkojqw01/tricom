require 'rails_helper'

RSpec.describe "jpt_holiday_msts/edit", type: :view do
  before(:each) do
    @jpt_holiday_mst = assign(:jpt_holiday_mst, JptHolidayMst.create!(
      :event_date => "MyString",
      :date, => "MyString",
      :title => "MyString",
      :string, => "MyString",
      :description => "MyString",
      :text => "MyString"
    ))
  end

  it "renders the edit jpt_holiday_mst form" do
    render

    assert_select "form[action=?][method=?]", jpt_holiday_mst_path(@jpt_holiday_mst), "post" do

      assert_select "input#jpt_holiday_mst_event_date[name=?]", "jpt_holiday_mst[event_date]"

      assert_select "input#jpt_holiday_mst_date,[name=?]", "jpt_holiday_mst[date,]"

      assert_select "input#jpt_holiday_mst_title[name=?]", "jpt_holiday_mst[title]"

      assert_select "input#jpt_holiday_mst_string,[name=?]", "jpt_holiday_mst[string,]"

      assert_select "input#jpt_holiday_mst_description[name=?]", "jpt_holiday_mst[description]"

      assert_select "input#jpt_holiday_mst_text[name=?]", "jpt_holiday_mst[text]"
    end
  end
end
