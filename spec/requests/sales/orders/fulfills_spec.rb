require 'rails_helper'

RSpec.describe "Sales::Orders::Fulfills", type: :request do
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

  before { sign_in create(:user) }

  describe "POST /create" do
    it "returns http success" do
      post "/sales/orders/#{sales_order.id}/fulfill"
      expect(response).to redirect_to(sales_order_path(sales_order))
      expect(flash[:notice]).to be_present
      expect(sales_order.reload.status).to eq("fulfilled")
      expect(sales_order.fulfilled_at).to within(1.second).of(Time.current)
      expect(sales_order.items.all?(&:delivered?)).to be true
    end

    context "with invalid status" do
      before do
        sales_order.update(status: "canceled")
      end

      it "does not change the sales order status" do
        post fulfill_sales_order_path(sales_order)
        sales_order.reload
        expect(sales_order.status).to eq("canceled")
        expect(flash[:alert]).to be_present
        expect(flash[:alert]).to include("El pedido no puede ser completado en su estado actual")
      end
    end
  end
end
