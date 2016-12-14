require "rails_helper"

RSpec.describe TsushinseigyousController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/tsushinseigyous").to route_to("tsushinseigyous#index")
    end

    it "routes to #new" do
      expect(:get => "/tsushinseigyous/new").to route_to("tsushinseigyous#new")
    end

    it "routes to #show" do
      expect(:get => "/tsushinseigyous/1").to route_to("tsushinseigyous#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/tsushinseigyous/1/edit").to route_to("tsushinseigyous#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/tsushinseigyous").to route_to("tsushinseigyous#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/tsushinseigyous/1").to route_to("tsushinseigyous#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/tsushinseigyous/1").to route_to("tsushinseigyous#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/tsushinseigyous/1").to route_to("tsushinseigyous#destroy", :id => "1")
    end

  end
end
