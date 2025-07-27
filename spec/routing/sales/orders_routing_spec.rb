require "rails_helper"

RSpec.describe Sales::OrdersController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/sales/orders").to route_to("sales/orders#index", department: "sales")
    end

    it "routes to #new" do
      expect(get: "/sales/orders/new").to route_to("sales/orders#new", department: "sales")
    end

    it "routes to #show" do
      expect(get: "/sales/orders/1").to route_to("sales/orders#show", id: "1", department: "sales")
    end

    it "routes to #edit" do
      expect(get: "/sales/orders/1/edit").to route_to("sales/orders#edit", id: "1", department: "sales")
    end


    it "routes to #create" do
      expect(post: "/sales/orders").to route_to("sales/orders#create", department: "sales")
    end

    it "routes to #update via PUT" do
      expect(put: "/sales/orders/1").to route_to("sales/orders#update", id: "1", department: "sales")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/sales/orders/1").to route_to("sales/orders#update", id: "1", department: "sales")
    end

    it "routes to #destroy" do
      expect(delete: "/sales/orders/1").to route_to("sales/orders#destroy", id: "1", department: "sales")
    end

    it "routes to #preview_totals" do
      expect(post: "/sales/orders/preview_totals").to route_to("sales/orders#preview_totals", department: "sales")
    end
  end
end
