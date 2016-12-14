require 'rails_helper'

RSpec.describe "jpt_holiday_msts/index", type: :view do
  before(:each) do
    assign(:jpt_holiday_msts, [
      JptHolidayMst.create!(
        :event_date => "Event Date",
        :date, => "Date,",
        :title => "Title",
        :string, => "String,",
        :description => "Description",
        :text => "Text"
      ),
      JptHolidayMst.create!(
        :event_date => "Event Date",
        :date, => "Date,",
        :title => "Title",
        :string, => "String,",
        :description => "Description",
        :text => "Text"
      )
    ])
  end

  it "renders a list of jpt_holiday_msts" do
    render
    assert_select "tr>td", :text => "Event Date".to_s, :count => 2
    assert_select "tr>td", :text => "Date,".to_s, :count => 2
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    assert_select "tr>td", :text => "String,".to_s, :count => 2
    assert_select "tr>td", :text => "Description".to_s, :count => 2
    assert_select "tr>td", :text => "Text".to_s, :count => 2
  end
end
