require 'rails_helper'

RSpec.describe "Sales::SalesOrders::Deliveries", type: :request do
  before { sign_in create(:user) }

  let(:client) { create(:client) }
  let(:product) { create(:purchased_productable) }
  let(:sales_order) do
    sales_order = build(:sales_order, client: client, status: :confirmed)
    sales_order
      .sales_order_items
      .build(attributes_for(:sales_order_item, product_id: product.id, quantity: 10, status: :ready))
    sales_order.save!
    sales_order
  end
  let(:sales_order_item) { sales_order.sales_order_items.first }

  describe "POST /create" do
    context "with valid status" do
      it "successfully changes the sales order item status" do
        post deliver_sales_sales_order_sales_order_item_path(sales_order, sales_order_item)

        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(sales_sales_order_path(sales_order))

        expect(sales_order_item.reload.status).to eq("delivered")
      end

      it "shows success notice" do
        post deliver_sales_sales_order_sales_order_item_path(sales_order, sales_order_item)

        expect(flash[:notice]).to be_present
      end

      context "when requesting turbo_stream format" do
        it "responds with turbo_stream" do
          post deliver_sales_sales_order_sales_order_item_path(sales_order, sales_order_item),
               headers: { 'Accept' => 'text/vnd.turbo-stream.html' }

          expect(response).to have_http_status(:ok)
          expect(response.content_type).to include('text/vnd.turbo-stream.html')
        end
      end
    end

    context "with invalid status" do
      before do
        sales_order_item.update(status: "cancelled")
      end

      it "does not change the sales order item status" do
        post deliver_sales_sales_order_sales_order_item_path(sales_order, sales_order_item)
        sales_order_item.reload
        expect(sales_order_item.status).to eq("cancelled")
        expect(flash[:alert]).to be_present
      end

      context "when requesting turbo_stream format" do
        it "responds with error turbo_stream" do
          post deliver_sales_sales_order_sales_order_item_path(sales_order, sales_order_item),
               headers: { 'Accept' => 'text/vnd.turbo-stream.html' }

          expect(response).to have_http_status(:ok)
          expect(response.content_type).to include('text/vnd.turbo-stream.html')
        end
      end
    end

    context "when sales order does not exist" do
      it "returns not found" do
        post deliver_sales_sales_order_sales_order_item_path(99999, sales_order_item)
        expect(response).to be_not_found
      end
    end

    context "when sales order item does not exist" do
      it "returns not found" do
        post deliver_sales_sales_order_sales_order_item_path(sales_order, 99999)
        expect(response).to be_not_found
      end
    end
  end
end
