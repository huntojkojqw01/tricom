require "rails_helper"

RSpec.describe KintaisController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/kintais").to route_to("kintais#index")
    end

    it "routes to #new" do
      expect(:get => "/kintais/new").to route_to("kintais#new")
    end

    it "routes to #show" do
      expect(:get => "/kintais/1").to route_to("kintais#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/kintais/1/edit").to route_to("kintais#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/kintais").to route_to("kintais#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/kintais/1").to route_to("kintais#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/kintais/1").to route_to("kintais#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/kintais/1").to route_to("kintais#destroy", :id => "1")
    end

  end
end
