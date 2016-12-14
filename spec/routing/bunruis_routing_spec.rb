require "rails_helper"

RSpec.describe BunruisController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/bunruis").to route_to("bunruis#index")
    end

    it "routes to #new" do
      expect(:get => "/bunruis/new").to route_to("bunruis#new")
    end

    it "routes to #show" do
      expect(:get => "/bunruis/1").to route_to("bunruis#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/bunruis/1/edit").to route_to("bunruis#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/bunruis").to route_to("bunruis#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/bunruis/1").to route_to("bunruis#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/bunruis/1").to route_to("bunruis#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/bunruis/1").to route_to("bunruis#destroy", :id => "1")
    end

  end
end
