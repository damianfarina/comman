require 'rails_helper'

RSpec.describe "/sales_orders", type: :request do
  before { sign_in create(:user) }

  describe "GET /index" do
    it "renders a successful response" do
      create(:sales_order, products_count: 1)
      get sales_sales_orders_url
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    let(:client) { create(:client) }
    let(:product) { create(:product, name: "Test Product", productable: build(:purchased_product)) }
    let(:valid_attributes) do
      {
        cash_discount_percentage: 10,
        client_discount_percentage: 5,
        client_id: client.id,
        comments: "Test order",
        sales_order_items_attributes: [
          {
            product_id: product.id,
            quantity: 2,
            _destroy: false,
          },
        ],
      }
    end

    it "creates a new SalesOrder" do
      expect {
        post sales_sales_orders_url, params: { sales_order: valid_attributes }
      }.to change(SalesOrder, :count).by(1)
      expect(response).to redirect_to(sales_sales_order_url(SalesOrder.last))
    end
  end
end
