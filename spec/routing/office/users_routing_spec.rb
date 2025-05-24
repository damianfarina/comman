require "rails_helper"

RSpec.describe Office::UsersController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/office/users").to route_to("office/users#index", department: "office")
    end

    it "routes to #new" do
      expect(get: "/office/users/new").to route_to("office/users#new", department: "office")
    end

    it "routes to #show" do
      expect(get: "/office/users/1").to route_to("office/users#show", id: "1", department: "office")
    end

    it "routes to #edit" do
      expect(get: "/office/users/1/edit").to route_to("office/users#edit", id: "1", department: "office")
    end


    it "routes to #create" do
      expect(post: "/office/users").to route_to("office/users#create", department: "office")
    end

    it "routes to #update via PUT" do
      expect(put: "/office/users/1").to route_to("office/users#update", id: "1", department: "office")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/office/users/1").to route_to("office/users#update", id: "1", department: "office")
    end

    it "routes to #destroy" do
      expect(delete: "/office/users/1").to route_to("office/users#destroy", id: "1", department: "office")
    end
  end
end
