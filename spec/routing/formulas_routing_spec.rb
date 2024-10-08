require "rails_helper"

RSpec.describe FormulasController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/formulas").to route_to("formulas#index")
    end

    it "routes to #new" do
      expect(get: "/formulas/new").to route_to("formulas#new")
    end

    it "routes to #show" do
      expect(get: "/formulas/1").to route_to("formulas#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/formulas/1/edit").to route_to("formulas#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/formulas").to route_to("formulas#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/formulas/1").to route_to("formulas#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/formulas/1").to route_to("formulas#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/formulas/1").to route_to("formulas#destroy", id: "1")
    end
  end
end
