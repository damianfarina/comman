require "spec_helper"

describe Business::ClientTypesController do
  describe "routing" do

    it "routes to #index" do
      get("/business/client_types").should route_to("business/client_types#index")
    end

    it "routes to #new" do
      get("/business/client_types/new").should route_to("business/client_types#new")
    end

    it "routes to #show" do
      get("/business/client_types/1").should route_to("business/client_types#show", :id => "1")
    end

    it "routes to #edit" do
      get("/business/client_types/1/edit").should route_to("business/client_types#edit", :id => "1")
    end

    it "routes to #create" do
      post("/business/client_types").should route_to("business/client_types#create")
    end

    it "routes to #update" do
      put("/business/client_types/1").should route_to("business/client_types#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/business/client_types/1").should route_to("business/client_types#destroy", :id => "1")
    end

  end
end
