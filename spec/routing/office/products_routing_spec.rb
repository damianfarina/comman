require "rails_helper"

RSpec.describe Office::ProductsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/office/products").to route_to("office/products#index", department: "office")
    end

    it "routes to #new" do
      expect(get: "/office/products/new").to route_to("office/products#new", department: "office")
    end

    it "routes to #show" do
      expect(get: "/office/products/1").to route_to("office/products#show", id: "1", department: "office")
    end

    it "routes to #edit" do
      expect(get: "/office/products/1/edit").to route_to("office/products#edit", id: "1", department: "office")
    end

    it "routes to #create" do
      expect(post: "/office/products").to route_to("office/products#create", department: "office")
    end

    it "routes to #update via PUT" do
      expect(put: "/office/products/1").to route_to("office/products#update", id: "1", department: "office")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/office/products/1").to route_to("office/products#update", id: "1", department: "office")
    end

    it "routes to #destroy" do
      expect(delete: "/office/products/1").to route_to("office/products#destroy", id: "1", department: "office")
    end
  end
end
