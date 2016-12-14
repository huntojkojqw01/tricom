require "rails_helper"

RSpec.describe DengonsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/dengons").to route_to("dengons#index")
    end

    it "routes to #new" do
      expect(:get => "/dengons/new").to route_to("dengons#new")
    end

    it "routes to #show" do
      expect(:get => "/dengons/1").to route_to("dengons#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/dengons/1/edit").to route_to("dengons#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/dengons").to route_to("dengons#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/dengons/1").to route_to("dengons#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/dengons/1").to route_to("dengons#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/dengons/1").to route_to("dengons#destroy", :id => "1")
    end

  end
end
