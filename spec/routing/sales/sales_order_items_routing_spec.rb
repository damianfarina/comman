require "rails_helper"

RSpec.describe "Sales::SalesOrderItems routing", type: :routing do
  describe "nested sales order item routes" do
    let(:order_id) { "1" }
    let(:sales_order_item_id) { "2" }

    describe "work_on routes" do
      it "routes POST to works#create" do
        expect(post: "/sales/orders/#{order_id}/sales_order_items/#{sales_order_item_id}/work_on").to route_to(
          controller: "sales/orders/items/works",
          action: "create",
          order_id: order_id,
          id: sales_order_item_id,
          department: "sales"
        )
      end

      it "generates the correct path" do
        expect(work_on_sales_order_sales_order_item_path(order_id, sales_order_item_id)).to eq(
          "/sales/orders/#{order_id}/sales_order_items/#{sales_order_item_id}/work_on"
        )
      end
    end

    describe "complete routes" do
      it "routes POST to completes#create" do
        expect(post: "/sales/orders/#{order_id}/sales_order_items/#{sales_order_item_id}/complete").to route_to(
          controller: "sales/orders/items/completes",
          action: "create",
          order_id: order_id,
          id: sales_order_item_id,
          department: "sales"
        )
      end

      it "generates the correct path" do
        expect(complete_sales_order_sales_order_item_path(order_id, sales_order_item_id)).to eq(
          "/sales/orders/#{order_id}/sales_order_items/#{sales_order_item_id}/complete"
        )
      end
    end

    describe "deliver routes" do
      it "routes POST to deliveries#create" do
        expect(post: "/sales/orders/#{order_id}/sales_order_items/#{sales_order_item_id}/deliver").to route_to(
          controller: "sales/orders/items/deliveries",
          action: "create",
          order_id: order_id,
          id: sales_order_item_id,
          department: "sales"
        )
      end

      it "generates the correct path" do
        expect(deliver_sales_order_sales_order_item_path(order_id, sales_order_item_id)).to eq(
          "/sales/orders/#{order_id}/sales_order_items/#{sales_order_item_id}/deliver"
        )
      end
    end

    describe "cancel routes" do
      it "routes POST to cancels#create" do
        expect(post: "/sales/orders/#{order_id}/sales_order_items/#{sales_order_item_id}/cancel").to route_to(
          controller: "sales/orders/items/cancels",
          action: "create",
          order_id: order_id,
          id: sales_order_item_id,
          department: "sales"
        )
      end

      it "generates the correct path" do
        expect(cancel_sales_order_sales_order_item_path(order_id, sales_order_item_id)).to eq(
          "/sales/orders/#{order_id}/sales_order_items/#{sales_order_item_id}/cancel"
        )
      end
    end

    describe "split routes" do
      it "routes GET to splits#new" do
        expect(get: "/sales/orders/#{order_id}/sales_order_items/#{sales_order_item_id}/split").to route_to(
          controller: "sales/orders/items/splits",
          action: "new",
          order_id: order_id,
          id: sales_order_item_id,
          department: "sales"
        )
      end

      it "routes POST to splits#create" do
        expect(post: "/sales/orders/#{order_id}/sales_order_items/#{sales_order_item_id}/split").to route_to(
          controller: "sales/orders/items/splits",
          action: "create",
          order_id: order_id,
          id: sales_order_item_id,
          department: "sales"
        )
      end

      it "generates the correct new split path" do
        expect(split_sales_order_sales_order_item_path(order_id, sales_order_item_id)).to eq(
          "/sales/orders/#{order_id}/sales_order_items/#{sales_order_item_id}/split"
        )
      end
    end
  end
end
