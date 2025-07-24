require 'rails_helper'

RSpec.describe "Sales::SalesOrders::Splits", type: :request do
  before { sign_in create(:user) }

  let(:client) { create(:client) }
  let(:product) { create(:purchased_productable) }
  let(:sales_order) do
    sales_order = build(:sales_order, client: client)
    sales_order
      .sales_order_items
      .build(attributes_for(:sales_order_item, product_id: product.id, quantity: 10, status: :in_progress))
    sales_order.save!
    sales_order
  end
  let(:sales_order_item) { sales_order.sales_order_items.first }

  describe "GET /new" do
    it "renders the new split form" do
      get split_sales_sales_order_sales_order_item_path(sales_order, sales_order_item)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("split")
    end

    context "when sales order does not exist" do
      it "returns 404 status" do
        get split_sales_sales_order_sales_order_item_path(99999, sales_order_item)
        expect(response).to be_not_found
      end
    end

    context "when sales order item does not exist" do
      it "returns 404 status" do
        get split_sales_sales_order_sales_order_item_path(sales_order, 99999)
        expect(response).to be_not_found
      end
    end
  end

  describe "POST /create" do
    let(:split_params) { { sales_order_item: { quantity: 3 } } }

    context "with valid parameters" do
      it "successfully splits the sales order item" do
        expect {
          post split_sales_sales_order_sales_order_item_path(sales_order, sales_order_item), params: split_params
        }.to change { sales_order.sales_order_items.count }.by(1)

        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(sales_sales_order_path(sales_order))

        expect(sales_order_item.reload.quantity).to eq(7)

        sales_order.reload
        new_item = sales_order.sales_order_items.last
        expect(new_item.quantity).to eq(3)
        expect(new_item.product).to eq(product)
      end

      it "shows success notice" do
        post split_sales_sales_order_sales_order_item_path(sales_order, sales_order_item), params: split_params

        expect(flash[:notice]).to be_present
      end

      context "when requesting turbo_stream format" do
        it "responds with turbo_stream" do
          post split_sales_sales_order_sales_order_item_path(sales_order, sales_order_item),
               params: split_params,
               headers: { 'Accept' => 'text/vnd.turbo-stream.html' }

          expect(response).to have_http_status(:ok)
          expect(response.content_type).to include('text/vnd.turbo-stream.html')
        end
      end

      context "when requesting json format" do
        it "responds with json" do
          post split_sales_sales_order_sales_order_item_path(sales_order, sales_order_item),
               params: split_params,
               headers: { 'Accept' => 'application/json' }

          expect(response).to have_http_status(:created)
          expect(response.content_type).to include('application/json')
        end
      end
    end

    context "with invalid parameters" do
      let(:invalid_split_params) { { sales_order_item: { quantity: 0 } } }

      it "does not split the sales order item" do
        expect {
          post split_sales_sales_order_sales_order_item_path(sales_order, sales_order_item), params: invalid_split_params
        }.not_to change { sales_order.sales_order_items.count }

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "renders the new template with errors" do
        post split_sales_sales_order_sales_order_item_path(sales_order, sales_order_item), params: invalid_split_params

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("split")
      end

      context "when requesting turbo_stream format" do
        it "responds with error turbo_stream" do
          post split_sales_sales_order_sales_order_item_path(sales_order, sales_order_item),
               params: invalid_split_params,
               headers: { 'Accept' => 'text/vnd.turbo-stream.html' }

          expect(response).to have_http_status(:ok)
          expect(response.content_type).to include('text/vnd.turbo-stream.html')
        end
      end

      context "when requesting json format" do
        it "responds with json errors" do
          post split_sales_sales_order_sales_order_item_path(sales_order, sales_order_item),
               params: invalid_split_params,
               headers: { 'Accept' => 'application/json' }

          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to include('application/json')
        end
      end
    end

    context "when split quantity is greater than or equal to current quantity" do
      let(:invalid_split_params) { { sales_order_item: { quantity: 15 } } }

      it "does not split the sales order item" do
        expect {
          post split_sales_sales_order_sales_order_item_path(sales_order, sales_order_item), params: invalid_split_params
        }.not_to change { sales_order.sales_order_items.count }

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "when sales order does not exist" do
      it "returns not found" do
        post split_sales_sales_order_sales_order_item_path(99999, sales_order_item), params: split_params
        expect(response).to be_not_found
      end
    end

    context "when sales order item does not exist" do
      it "returns not found" do
        post split_sales_sales_order_sales_order_item_path(sales_order, 99999), params: split_params
        expect(response).to be_not_found
      end
    end

    context "without required parameters" do
      it "returns bad request" do
        post split_sales_sales_order_sales_order_item_path(sales_order, sales_order_item), params: {}
        expect(response).to be_bad_request
      end
    end
  end
end
