require 'rails_helper'

RSpec.describe "Sales::SalesOrders::Confirmations", type: :request do
  let(:user) { create(:user) }
  let(:client) { create(:client) }
  let(:product) { create(:purchased_productable) }
  let(:sales_order) do
    sales_order = build(:sales_order, client: client)
    sales_order
      .sales_order_items
      .build(attributes_for(
        :sales_order_item,
        product_id: product.id,
        quantity: 10,
        unit_price: 100.00,
        status: 'quote',
      ))
    sales_order.save!
    sales_order
  end
  let(:sales_order_item) { sales_order.sales_order_items.first }

  before do
    sign_in(user)
  end

  describe "POST /create" do
    context "when sales order can be confirmed" do
      it "confirms the sales order and redirects with success notice" do
        expect(sales_order).to be_quote
        expect(sales_order.can_confirm?).to be true

        post confirm_sales_sales_order_path(sales_order)

        expect(response).to redirect_to(sales_sales_order_path(sales_order))
        expect(flash[:notice]).to be_present

        sales_order.reload
        expect(sales_order).to be_confirmed
        expect(sales_order.confirmed_at).to be_present
        expect(sales_order.total_price).to eq(sales_order.subtotal_after_order_discount)
      end

      it "updates sales order items status to confirmed" do
        expect(sales_order_item.status).to eq('quote')

        post confirm_sales_sales_order_path(sales_order)

        sales_order_item.reload
        expect(sales_order_item.status).to eq('confirmed')
      end

      it "sets the confirmed_at timestamp" do
        post confirm_sales_sales_order_path(sales_order)

        sales_order.reload
        expect(sales_order.confirmed_at).to be_within(1.second).of(Time.current)
      end
    end

    context "when sales order cannot be confirmed" do
      context "because it's already confirmed" do
        before do
          sales_order.update!(status: 'confirmed', confirmed_at: 1.day.ago)
        end

        it "redirects with error message" do
          post confirm_sales_sales_order_path(sales_order)

          expect(response).to redirect_to(sales_sales_order_path(sales_order))
          expect(flash[:alert]).to be_present
          expect(flash[:alert]).to include("Falló la confirmación del pedido: El pedido no puede ser confirmado en su estado actual o sus ítems no son válidos.")
        end
      end

      context "because it has no confirmable items" do
        before do
          sales_order_item.update!(status: 'cancelled')
        end

        it "redirects with error message" do
          post confirm_sales_sales_order_path(sales_order)

          expect(response).to redirect_to(sales_sales_order_path(sales_order))
          expect(flash[:alert]).to be_present
        end
      end
    end

    context "when sales order does not exist" do
      it "raises ActiveRecord::RecordNotFound" do
        post confirm_sales_sales_order_path(id: 999999)
        expect(response).to have_http_status(:not_found)
      end
    end

    context "when there's a database error during confirmation" do
      before do
        allow_any_instance_of(SalesOrder).to receive(:save!).and_raise(ActiveRecord::RecordInvalid.new(sales_order))
      end

      it "redirects with error message" do
        post confirm_sales_sales_order_path(sales_order)

        expect(response).to redirect_to(sales_sales_order_path(sales_order))
        expect(flash[:alert]).to be_present
      end
    end

    context "with different sales order statuses" do
      it "cannot confirm a cancelled order" do
        sales_order.update!(status: 'cancelled', cancelled_at: 1.day.ago)

        post confirm_sales_sales_order_path(sales_order)

        expect(response).to redirect_to(sales_sales_order_path(sales_order))
        expect(flash[:alert]).to be_present
      end

      it "cannot confirm a fulfilled order" do
        sales_order.update!(status: 'fulfilled', fulfilled_at: 1.day.ago)

        post confirm_sales_sales_order_path(sales_order)

        expect(response).to redirect_to(sales_sales_order_path(sales_order))
        expect(flash[:alert]).to be_present
      end
    end

    context "with complex sales order scenarios" do
      let!(:additional_item) do
        create(:sales_order_item,
               sales_order: sales_order,
               product: product,
               quantity: 5,
               unit_price: 200.00,
               status: 'quote')
      end

      it "confirms orders with multiple items" do
        expect(sales_order.sales_order_items.count).to eq(2)

        post confirm_sales_sales_order_path(sales_order)

        expect(response).to redirect_to(sales_sales_order_path(sales_order))
        expect(flash[:notice]).to be_present

        sales_order.reload
        expect(sales_order).to be_confirmed
        expect(sales_order.sales_order_items.confirmed.count).to eq(2)
      end

      it "calculates correct total price with discounts" do
        sales_order.update!(client_discount_percentage: 10, cash_discount_percentage: 5)

        post confirm_sales_sales_order_path(sales_order)

        sales_order.reload
        expected_subtotal = (10 * 100.00) + (5 * 200.00) # 2000
        expected_after_client_discount = expected_subtotal * 0.9 # 1800
        expect(sales_order.total_price).to eq(expected_after_client_discount)
      end
    end

    context "when user is not authenticated" do
      before do
        sign_out
      end

      it "redirects to login" do
        post confirm_sales_sales_order_path(sales_order)

        expect(response).to have_http_status(:found)
      end
    end
  end
end
