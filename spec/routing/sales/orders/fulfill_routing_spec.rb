require "rails_helper"

RSpec.describe Sales::Orders::FulfillController, type: :routing do
  describe "routing" do
    it "routes to #create" do
      expect(post: "/sales/orders/1/fulfill").to \
        route_to("sales/orders/fulfill#create", id: "1", department: "sales")
    end
  end
end
