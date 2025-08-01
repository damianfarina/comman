require 'rails_helper'

RSpec.describe "/factory/making_orders", type: :request do
  let(:formula) { create(:formula, :with_items) }
  let(:product) { create(:manufactured_productable, formula: formula) }

  let(:valid_attributes) {
    {
      comments: "comments",
      mixer_capacity: 60,
      making_order_items_attributes: [
        {
          product_id: product.id,
          quantity: 1,
        },
      ],
    }
  }

  let(:invalid_attributes) {
    {
      making_order_items_attributes: [
        {
          product_id: product.id,
          quantity: 1,
          _destroy: true,
        },
      ],
    }
  }

  before { sign_in create(:user) }

  describe "GET /index" do
    it "renders a successful response" do
      create(:making_order, :with_products)
      get factory_making_orders_url
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      making_order = create(:making_order, :with_products)
      get factory_making_order_url(making_order)
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_factory_making_order_url
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "renders a successful response" do
      making_order = create(:making_order, :with_products)
      get edit_factory_making_order_url(making_order)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new MakingOrder" do
        expect {
          post factory_making_orders_url, params: { making_order: valid_attributes }
        }.to change(MakingOrder, :count).by(1)
      end

      it "redirects to the created making_order" do
        post factory_making_orders_url, params: { making_order: valid_attributes }
        expect(response).to redirect_to(factory_making_order_url(MakingOrder.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new MakingOrder" do
        expect {
          post factory_making_orders_url, params: { making_order: invalid_attributes }
        }.to change(MakingOrder, :count).by(0)
      end

      it "renders a response with 422 status (i.e. to display the 'new' template)" do
        post factory_making_orders_url, params: { making_order: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        { comments: "new comment" }
      }

      it "updates the requested making_order" do
        making_order = MakingOrder.create! valid_attributes
        patch factory_making_order_url(making_order), params: { making_order: new_attributes }
        making_order.reload
        expect(making_order.comments.to_plain_text).to eq("new comment")
      end

      it "redirects to the making_order" do
        making_order = MakingOrder.create! valid_attributes
        patch factory_making_order_url(making_order), params: { making_order: new_attributes }
        making_order.reload
        expect(response).to redirect_to(factory_making_order_url(making_order))
      end
    end

    context "with invalid parameters" do
      it "renders a response with 422 status (i.e. to display the 'edit' template)" do
        making_order = MakingOrder.create! valid_attributes
        patch factory_making_order_url(making_order), params: { making_order: invalid_attributes.merge({
          making_order_items_attributes: making_order.making_order_items.map { |item| item.attributes.merge(_destroy: true) },
        }) }
        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested making_order" do
      making_order = create(:making_order, :with_products)
      expect {
        delete factory_making_order_url(making_order)
    }.to raise_error(RuntimeError, "Making orders cannot be destroyed! They are part of the production history. Implement archiving instead.")
    end
  end
end
