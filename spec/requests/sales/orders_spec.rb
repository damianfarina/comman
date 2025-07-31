require 'rails_helper'

RSpec.describe "/orders", type: :request do
  before { sign_in create(:user) }

  describe "GET /index" do
    it "renders a successful response" do
      create(:sales_order, products_count: 1)
      get sales_orders_url
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    let(:client) { create(:client, name: "Test Client") }
    it "renders a successful response" do
      create(:sales_order, products_count: 1)
      get new_sales_order_url(client_id: client.id)
      expect(response).to be_successful
      expect(response.body).to include("Test Client")
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
        items_attributes: [
          {
            product_id: product.id,
            quantity: 2,
            _destroy: false,
          },
        ],
      }
    end

    it "creates a new Order" do
      expect {
        post sales_orders_url, params: { sales_order: valid_attributes }
      }.to change(Sales::Order, :count).by(1)
      expect(response).to redirect_to(sales_order_url(Sales::Order.last))
    end

    it "confirms the order" do
      post sales_orders_url, params: { sales_order: valid_attributes, commit: "confirm" }
      expect(response).to redirect_to(sales_order_url(Sales::Order.last))
      expect(Sales::Order.last).to be_confirmed
    end
  end

  describe "PATCH /update" do
    let(:sales_order) { create(:sales_order, products_count: 1) }
    let(:valid_attributes) do
      {
        comments: "Updated order",
        items_attributes: [
          {
            id: sales_order.items.first.id,
            product_id: sales_order.items.first.product_id,
            quantity: 3,
            _destroy: false,
          },
        ],
      }
    end

    it "updates the Order" do
      patch sales_order_url(sales_order), params: { sales_order: valid_attributes }
      sales_order.reload
      expect(sales_order.comments_plain_text).to eq("Updated order")
      expect(sales_order.items.first.quantity).to eq(3)
      expect(response).to redirect_to(edit_sales_order_url(sales_order))
    end

    it "confirms the order" do
      patch sales_order_url(sales_order), params: { sales_order: valid_attributes, commit: "confirm" }
      expect(response).to redirect_to(edit_sales_order_url(sales_order))
      expect(sales_order.reload).to be_confirmed
      follow_redirect!
      expect(response).to redirect_to(sales_order_url(sales_order))
    end
  end

  describe "GET /show" do
    let(:sales_order) { create(:sales_order, products_count: 1) }

    it "renders a successful response if order is confirmed" do
      sales_order.confirm!
      get sales_order_url(sales_order)
      expect(response).to be_successful
    end

    it "redirects to edit page if order is quote" do
      sales_order.update(status: "quote")
      get sales_order_url(sales_order)
      expect(response).to redirect_to(edit_sales_order_url(sales_order))
    end
  end

  describe "DELETE /destroy" do
    let(:sales_order) { create(:sales_order, products_count: 1, status: "confirmed") }

    it "cancels the Order" do
      delete sales_order_url(sales_order)
      sales_order.reload
      expect(sales_order).to be_canceled
      expect(sales_order.items.all?(&:canceled?)).to be true
      expect(sales_order.items.count).to eq(1)
      expect(response).to redirect_to(sales_order_url(sales_order))
      follow_redirect!
      expect(response.body).to include("Cancelado")
    end

    it "does not allow canceling a fulfilled order" do
      sales_order.fulfill!
      delete sales_order_url(sales_order)
      expect(response).to redirect_to(sales_order_url(sales_order))
      expect(flash[:alert]).to include("Falló la cancelación del pedido")
    end
  end
end
