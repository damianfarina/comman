require "rails_helper"

RSpec.describe Office::SuppliersController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/office/suppliers").to route_to("office/suppliers#index", department: "office")
    end

    it "routes to #new" do
      expect(get: "/office/suppliers/new").to route_to("office/suppliers#new", department: "office")
    end

    it "routes to #show" do
      expect(get: "/office/suppliers/1").to route_to("office/suppliers#show", id: "1", department: "office")
    end

    it "routes to #edit" do
      expect(get: "/office/suppliers/1/edit").to route_to("office/suppliers#edit", id: "1", department: "office")
    end

    it "routes to #create" do
      expect(post: "/office/suppliers").to route_to("office/suppliers#create", department: "office")
    end

    it "routes to #update via PUT" do
      expect(put: "/office/suppliers/1").to route_to("office/suppliers#update", id: "1", department: "office")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/office/suppliers/1").to route_to("office/suppliers#update", id: "1", department: "office")
    end

    it "routes to #destroy" do
      expect(delete: "/office/suppliers/1").to route_to("office/suppliers#destroy", id: "1", department: "office")
    end
  end
end
