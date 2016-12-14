require 'rails_helper'

RSpec.describe "JptHolidayMsts", type: :request do
  describe "GET /jpt_holiday_msts" do
    it "works! (now write some real specs)" do
      get jpt_holiday_msts_path
      expect(response).to have_http_status(200)
    end
  end
end
