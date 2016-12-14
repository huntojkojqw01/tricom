require "rails_helper"

RSpec.describe DengonkaitousController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/dengonkaitous").to route_to("dengonkaitous#index")
    end

    it "routes to #new" do
      expect(:get => "/dengonkaitous/new").to route_to("dengonkaitous#new")
    end

    it "routes to #show" do
      expect(:get => "/dengonkaitous/1").to route_to("dengonkaitous#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/dengonkaitous/1/edit").to route_to("dengonkaitous#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/dengonkaitous").to route_to("dengonkaitous#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/dengonkaitous/1").to route_to("dengonkaitous#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/dengonkaitous/1").to route_to("dengonkaitous#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/dengonkaitous/1").to route_to("dengonkaitous#destroy", :id => "1")
    end

  end
end
