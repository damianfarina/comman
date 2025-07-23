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

    it "confirms the order" do
      post sales_sales_orders_url, params: { sales_order: valid_attributes, commit: "confirm" }
      expect(response).to redirect_to(sales_sales_order_url(SalesOrder.last))
      expect(SalesOrder.last).to be_confirmed
    end
  end

  describe "PATCH /update" do
    let(:sales_order) { create(:sales_order, products_count: 1) }
    let(:valid_attributes) do
      {
        cash_discount_percentage: 50,
        client_discount_percentage: 60,
        comments: "Updated order",
      }
    end

    it "updates the SalesOrder" do
      patch sales_sales_order_url(sales_order), params: { sales_order: valid_attributes }
      sales_order.reload
      expect(sales_order.cash_discount_percentage).to eq(50)
      expect(sales_order.client_discount_percentage).to eq(60)
      expect(response).to redirect_to(edit_sales_sales_order_url(sales_order))
    end

    it "confirms the order" do
      patch sales_sales_order_url(sales_order), params: { sales_order: valid_attributes, commit: "confirm" }
      expect(response).to redirect_to(edit_sales_sales_order_url(sales_order))
      expect(sales_order.reload).to be_confirmed
      follow_redirect!
      expect(response).to redirect_to(sales_sales_order_url(sales_order))
    end
  end

  describe "GET /show" do
    let(:sales_order) { create(:sales_order, products_count: 1) }

    it "renders a successful response if order is confirmed" do
      sales_order.confirm!
      get sales_sales_order_url(sales_order)
      expect(response).to be_successful
    end

    it "redirects to edit page if order is quote" do
      sales_order.update(status: "quote")
      get sales_sales_order_url(sales_order)
      expect(response).to redirect_to(edit_sales_sales_order_url(sales_order))
    end
  end
end
