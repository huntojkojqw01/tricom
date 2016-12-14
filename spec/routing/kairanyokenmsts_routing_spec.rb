require "rails_helper"

RSpec.describe KairanyokenmstsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/kairanyokenmsts").to route_to("kairanyokenmsts#index")
    end

    it "routes to #new" do
      expect(:get => "/kairanyokenmsts/new").to route_to("kairanyokenmsts#new")
    end

    it "routes to #show" do
      expect(:get => "/kairanyokenmsts/1").to route_to("kairanyokenmsts#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/kairanyokenmsts/1/edit").to route_to("kairanyokenmsts#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/kairanyokenmsts").to route_to("kairanyokenmsts#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/kairanyokenmsts/1").to route_to("kairanyokenmsts#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/kairanyokenmsts/1").to route_to("kairanyokenmsts#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/kairanyokenmsts/1").to route_to("kairanyokenmsts#destroy", :id => "1")
    end

  end
end
