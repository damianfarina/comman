require 'rails_helper'

RSpec.describe "/making_orders", type: :request do
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  before { sign_in create(:user) }

  describe "GET /index" do
    it "renders a successful response" do
      MakingOrder.create! valid_attributes
      get factory_making_orders_url
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      making_order = MakingOrder.create! valid_attributes
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
      making_order = MakingOrder.create! valid_attributes
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
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested making_order" do
        making_order = MakingOrder.create! valid_attributes
        patch factory_making_order_url(making_order), params: { making_order: new_attributes }
        making_order.reload
        skip("Add assertions for updated state")
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
        patch factory_making_order_url(making_order), params: { making_order: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested making_order" do
      making_order = MakingOrder.create! valid_attributes
      expect {
        delete factory_making_order_url(making_order)
      }.to change(MakingOrder, :count).by(-1)
    end

    it "redirects to the making_orders list" do
      making_order = MakingOrder.create! valid_attributes
      delete factory_making_order_url(making_order)
      expect(response).to redirect_to(factory_making_orders_url)
    end
  end
end
