require "rails_helper"

RSpec.describe Factory::FormulasController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/factory/formulas").to route_to("factory/formulas#index")
    end

    it "routes to #new" do
      expect(get: "/factory/formulas/new").to route_to("factory/formulas#new")
    end

    it "routes to #show" do
      expect(get: "/factory/formulas/1").to route_to("factory/formulas#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/factory/formulas/1/edit").to route_to("factory/formulas#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/factory/formulas").to route_to("factory/formulas#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/factory/formulas/1").to route_to("factory/formulas#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/factory/formulas/1").to route_to("factory/formulas#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/factory/formulas/1").to route_to("factory/formulas#destroy", id: "1")
    end
  end
end
