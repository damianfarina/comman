require 'rails_helper'

RSpec.describe "Sales::Orders::Items::Cancels", type: :request do
  before { sign_in create(:user) }

  let(:client) { create(:client) }
  let(:product) { create(:purchased_productable) }
  let(:sales_order) do
    sales_order = build(:sales_order, client: client, status: :confirmed)
    sales_order
      .items
      .build(attributes_for(:sales_order_item, product_id: product.id, quantity: 10, status: :confirmed))
    sales_order.total_price = sales_order.subtotal_after_order_discount
    sales_order.save!
    sales_order
  end
  let(:sales_order_item) { sales_order.items.first }

  describe "POST /create" do
    context "with valid status" do
      it "successfully changes the sales order item status" do
        post cancel_sales_order_item_path(sales_order, sales_order_item)

        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(sales_order_path(sales_order))

        expect(sales_order_item.reload.status).to eq("canceled")
      end

      it "shows success notice" do
        post cancel_sales_order_item_path(sales_order, sales_order_item)

        expect(flash[:notice]).to be_present
      end

      context "when requesting turbo_stream format" do
        it "responds with turbo_stream" do
          post cancel_sales_order_item_path(sales_order, sales_order_item),
               headers: { 'Accept' => 'text/vnd.turbo-stream.html' }

          expect(response).to have_http_status(:ok)
          expect(response.content_type).to include('text/vnd.turbo-stream.html')
        end
      end

      it "updates the sales order total price" do
        sales_order.confirm!
        total_before_cancel = sales_order.total_price
        post cancel_sales_order_item_path(sales_order, sales_order_item)
        expect(sales_order.reload.total_price).to eq(total_before_cancel - sales_order_item.subtotal)
      end
    end

    context "with invalid status" do
      before do
        sales_order_item.update(status: "delivered")
      end

      it "does not change the sales order item status" do
        post cancel_sales_order_item_path(sales_order, sales_order_item)
        sales_order_item.reload
        expect(sales_order_item.status).to eq("delivered")
        expect(flash[:alert]).to be_present
      end

      context "when requesting turbo_stream format" do
        it "responds with error turbo_stream" do
          post cancel_sales_order_item_path(sales_order, sales_order_item),
               headers: { 'Accept' => 'text/vnd.turbo-stream.html' }

          expect(response).to have_http_status(:ok)
          expect(response.content_type).to include('text/vnd.turbo-stream.html')
        end
      end
    end
  end
end
