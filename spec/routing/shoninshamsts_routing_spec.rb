require "rails_helper"

RSpec.describe ShoninshamstsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/shoninshamsts").to route_to("shoninshamsts#index")
    end

    it "routes to #new" do
      expect(:get => "/shoninshamsts/new").to route_to("shoninshamsts#new")
    end

    it "routes to #show" do
      expect(:get => "/shoninshamsts/1").to route_to("shoninshamsts#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/shoninshamsts/1/edit").to route_to("shoninshamsts#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/shoninshamsts").to route_to("shoninshamsts#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/shoninshamsts/1").to route_to("shoninshamsts#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/shoninshamsts/1").to route_to("shoninshamsts#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/shoninshamsts/1").to route_to("shoninshamsts#destroy", :id => "1")
    end

  end
end
