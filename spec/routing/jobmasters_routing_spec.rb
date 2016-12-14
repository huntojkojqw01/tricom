require "rails_helper"

RSpec.describe JobmastersController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/jobmasters").to route_to("jobmasters#index")
    end

    it "routes to #new" do
      expect(:get => "/jobmasters/new").to route_to("jobmasters#new")
    end

    it "routes to #show" do
      expect(:get => "/jobmasters/1").to route_to("jobmasters#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/jobmasters/1/edit").to route_to("jobmasters#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/jobmasters").to route_to("jobmasters#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/jobmasters/1").to route_to("jobmasters#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/jobmasters/1").to route_to("jobmasters#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/jobmasters/1").to route_to("jobmasters#destroy", :id => "1")
    end

  end
end
