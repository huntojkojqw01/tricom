require "rails_helper"

RSpec.describe KeihisController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/keihis").to route_to("keihis#index")
    end

    it "routes to #new" do
      expect(:get => "/keihis/new").to route_to("keihis#new")
    end

    it "routes to #show" do
      expect(:get => "/keihis/1").to route_to("keihis#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/keihis/1/edit").to route_to("keihis#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/keihis").to route_to("keihis#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/keihis/1").to route_to("keihis#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/keihis/1").to route_to("keihis#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/keihis/1").to route_to("keihis#destroy", :id => "1")
    end

  end
end
