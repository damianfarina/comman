require "rails_helper"

RSpec.describe Sales::ClientsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/sales/clients").to route_to("sales/clients#index", department: "sales")
    end
  end
end
