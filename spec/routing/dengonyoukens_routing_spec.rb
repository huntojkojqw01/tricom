require "rails_helper"

RSpec.describe DengonyoukensController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/dengonyoukens").to route_to("dengonyoukens#index")
    end

    it "routes to #new" do
      expect(:get => "/dengonyoukens/new").to route_to("dengonyoukens#new")
    end

    it "routes to #show" do
      expect(:get => "/dengonyoukens/1").to route_to("dengonyoukens#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/dengonyoukens/1/edit").to route_to("dengonyoukens#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/dengonyoukens").to route_to("dengonyoukens#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/dengonyoukens/1").to route_to("dengonyoukens#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/dengonyoukens/1").to route_to("dengonyoukens#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/dengonyoukens/1").to route_to("dengonyoukens#destroy", :id => "1")
    end

  end
end
