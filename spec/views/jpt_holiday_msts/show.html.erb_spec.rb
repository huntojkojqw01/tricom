require 'rails_helper'

RSpec.describe "jpt_holiday_msts/show", type: :view do
  before(:each) do
    @jpt_holiday_mst = assign(:jpt_holiday_mst, JptHolidayMst.create!(
      :event_date => "Event Date",
      :date, => "Date,",
      :title => "Title",
      :string, => "String,",
      :description => "Description",
      :text => "Text"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Event Date/)
    expect(rendered).to match(/Date,/)
    expect(rendered).to match(/Title/)
    expect(rendered).to match(/String,/)
    expect(rendered).to match(/Description/)
    expect(rendered).to match(/Text/)
  end
end
