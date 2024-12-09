require "rails_helper"

RSpec.describe MakingOrdersController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/making_orders").to route_to("making_orders#index")
    end

    it "routes to #new" do
      expect(get: "/making_orders/new").to route_to("making_orders#new")
    end

    it "routes to #show" do
      expect(get: "/making_orders/1").to route_to("making_orders#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/making_orders/1/edit").to route_to("making_orders#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/making_orders").to route_to("making_orders#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/making_orders/1").to route_to("making_orders#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/making_orders/1").to route_to("making_orders#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/making_orders/1").to route_to("making_orders#destroy", id: "1")
    end
  end
end
