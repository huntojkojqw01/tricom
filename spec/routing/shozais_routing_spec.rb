require "rails_helper"

RSpec.describe ShozaisController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/shozais").to route_to("shozais#index")
    end

    it "routes to #new" do
      expect(:get => "/shozais/new").to route_to("shozais#new")
    end

    it "routes to #show" do
      expect(:get => "/shozais/1").to route_to("shozais#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/shozais/1/edit").to route_to("shozais#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/shozais").to route_to("shozais#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/shozais/1").to route_to("shozais#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/shozais/1").to route_to("shozais#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/shozais/1").to route_to("shozais#destroy", :id => "1")
    end

  end
end
