require "rails_helper"

RSpec.describe KikanmstsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/kikanmsts").to route_to("kikanmsts#index")
    end

    it "routes to #new" do
      expect(:get => "/kikanmsts/new").to route_to("kikanmsts#new")
    end

    it "routes to #show" do
      expect(:get => "/kikanmsts/1").to route_to("kikanmsts#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/kikanmsts/1/edit").to route_to("kikanmsts#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/kikanmsts").to route_to("kikanmsts#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/kikanmsts/1").to route_to("kikanmsts#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/kikanmsts/1").to route_to("kikanmsts#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/kikanmsts/1").to route_to("kikanmsts#destroy", :id => "1")
    end

  end
end
