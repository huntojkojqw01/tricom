require "rails_helper"

RSpec.describe JptHolidayMstsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/jpt_holiday_msts").to route_to("jpt_holiday_msts#index")
    end

    it "routes to #new" do
      expect(:get => "/jpt_holiday_msts/new").to route_to("jpt_holiday_msts#new")
    end

    it "routes to #show" do
      expect(:get => "/jpt_holiday_msts/1").to route_to("jpt_holiday_msts#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/jpt_holiday_msts/1/edit").to route_to("jpt_holiday_msts#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/jpt_holiday_msts").to route_to("jpt_holiday_msts#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/jpt_holiday_msts/1").to route_to("jpt_holiday_msts#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/jpt_holiday_msts/1").to route_to("jpt_holiday_msts#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/jpt_holiday_msts/1").to route_to("jpt_holiday_msts#destroy", :id => "1")
    end

  end
end
