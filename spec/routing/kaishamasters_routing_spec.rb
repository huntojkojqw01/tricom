require "rails_helper"

RSpec.describe KaishamastersController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/kaishamasters").to route_to("kaishamasters#index")
    end

    it "routes to #new" do
      expect(:get => "/kaishamasters/new").to route_to("kaishamasters#new")
    end

    it "routes to #show" do
      expect(:get => "/kaishamasters/1").to route_to("kaishamasters#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/kaishamasters/1/edit").to route_to("kaishamasters#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/kaishamasters").to route_to("kaishamasters#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/kaishamasters/1").to route_to("kaishamasters#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/kaishamasters/1").to route_to("kaishamasters#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/kaishamasters/1").to route_to("kaishamasters#destroy", :id => "1")
    end

  end
end
