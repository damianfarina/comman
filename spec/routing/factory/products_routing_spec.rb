require "rails_helper"

RSpec.describe Factory::ProductsController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/factory/products").to route_to("factory/products#index")
    end

    it "routes to #new" do
      expect(:get => "/factory/products/new").to route_to("factory/products#new")
    end

    it "routes to #show" do
      expect(:get => "/factory/products/1").to route_to("factory/products#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/factory/products/1/edit").to route_to("factory/products#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/factory/products").to route_to("factory/products#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/factory/products/1").to route_to("factory/products#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/factory/products/1").to route_to("factory/products#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/factory/products/1").to route_to("factory/products#destroy", :id => "1")
    end

  end
end
