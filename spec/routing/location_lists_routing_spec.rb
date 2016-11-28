require "rails_helper"

RSpec.describe LocationListsController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/location_lists").to route_to("location_lists#index")
    end

    it "routes to #new" do
      expect(:get => "/location_lists/new").to route_to("location_lists#new")
    end

    it "routes to #show" do
      expect(:get => "/location_lists/1").to route_to("location_lists#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/location_lists/1/edit").to route_to("location_lists#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/location_lists").to route_to("location_lists#create")
    end

    it "routes to #update" do
      expect(:put => "/location_lists/1").to route_to("location_lists#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/location_lists/1").to route_to("location_lists#destroy", :id => "1")
    end

  end
end
