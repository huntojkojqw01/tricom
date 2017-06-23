require "rails_helper"

RSpec.describe KairansController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/kairans").to route_to("kairans#index")
    end

    it "routes to #new" do
      expect(:get => "/kairans/new").to route_to("kairans#new")
    end

    it "routes to #show" do
      expect(:get => "/kairans/1").to route_to("kairans#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/kairans/1/edit").to route_to("kairans#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/kairans").to route_to("kairans#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/kairans/1").to route_to("kairans#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/kairans/1").to route_to("kairans#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/kairans/1").to route_to("kairans#destroy", :id => "1")
    end

  end
end
