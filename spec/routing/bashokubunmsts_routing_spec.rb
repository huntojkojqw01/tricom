require "rails_helper"

RSpec.describe BashokubunmstsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/bashokubunmsts").to route_to("bashokubunmsts#index")
    end

    it "routes to #new" do
      expect(:get => "/bashokubunmsts/new").to route_to("bashokubunmsts#new")
    end

    it "routes to #show" do
      expect(:get => "/bashokubunmsts/1").to route_to("bashokubunmsts#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/bashokubunmsts/1/edit").to route_to("bashokubunmsts#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/bashokubunmsts").to route_to("bashokubunmsts#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/bashokubunmsts/1").to route_to("bashokubunmsts#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/bashokubunmsts/1").to route_to("bashokubunmsts#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/bashokubunmsts/1").to route_to("bashokubunmsts#destroy", :id => "1")
    end

  end
end
