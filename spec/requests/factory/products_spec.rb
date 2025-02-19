require 'rails_helper'

RSpec.describe "/products", type: :request do
  let(:formula) { create(:formula, :with_items, abrasive: "A", grain: "B", hardness: "C", porosity: "D", alloy: "E") }
  let(:valid_attributes) {
    {
      price: 10.0,
      formula_id: formula.id,
      shape: "RR",
      size: "250x100x50",
      weight: 10.0,
      pressure: "G100",
    }
  }

  let(:invalid_attributes) {
    {
      price: "FREE",
      formula_id: formula.id,
      shape: "RR",
      size: "150x100x50",
      weight: "HEAVY",
      pressure: "G100",
    }
  }

  before { sign_in create(:user) }

  describe "GET /index" do
    it "renders a successful response" do
      Product.create! valid_attributes
      get factory_products_url
      expect(response).to be_successful
    end

    context "with IdSearchQueryProcessor" do
      let!(:product1) { create(:product, id: 1234, shape: "RR", size: "250x100x50", weight: 10.0, pressure: "G100", formula: formula) }
      let!(:product2) { create(:product, id: 5678, shape: "SQ", size: "300x150x75", weight: 12.5, pressure: "G120", formula: formula) }

      context "when params[:q] contains id_or_name_cont with #1234" do
        it "filters by ID" do
          get factory_products_url, params: { q: { "id_or_name_cont" => "#1234" } }, as: :json

          json_response = JSON.parse(response.body)
          expect(response).to be_successful
          expect(json_response.pluck("id")).to contain_exactly(1234)
        end
      end

      context "when params[:q] contains id_or_description_cont with #5678" do
        it "filters by ID" do
          get factory_products_url, params: { q: { "id_or_description_cont" => "#5678" } }, as: :json

          json_response = JSON.parse(response.body)
          expect(response).to be_successful
          expect(json_response.pluck("id")).to contain_exactly(5678)
        end
      end

      context "when params[:q] does not contain any id_or_* keys" do
        it "returns RR products" do
          get factory_products_url, params: { q: { "name_cont" => "RR" } }, as: :json

          json_response = JSON.parse(response.body)
          expect(response).to be_successful
          expect(json_response.pluck("id")).to match_array([ product1.id ])
        end
      end

      context "when params[:q] contains id_or_* keys but the value is missing the id" do
        it "returns no products" do
          get factory_products_url, params: { q: { "id_or_name_cont" => "1234" } }, as: :json

          json_response = JSON.parse(response.body)
          expect(response).to be_successful
          expect(json_response.pluck("id")).to match_array([])
        end
      end
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      product = Product.create! valid_attributes
      get factory_product_url(product)
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_factory_product_url
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "renders a successful response" do
      product = Product.create! valid_attributes
      get edit_factory_product_url(product)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Product" do
        expect {
          post factory_products_url, params: { product: valid_attributes }
        }.to change(Product, :count).by(1)
      end

      it "redirects to the created product" do
        post factory_products_url, params: { product: valid_attributes }
        expect(response).to redirect_to(factory_product_url(Product.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Product" do
        expect {
          post factory_products_url, params: { product: invalid_attributes }
        }.to change(Product, :count).by(0)
      end

      it "renders a response with 422 status (i.e. to display the 'new' template)" do
        post factory_products_url, params: { product: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        {
          price: 20.0,
        }
      }

      it "updates the requested product" do
        product = Product.create! valid_attributes
        patch factory_product_url(product), params: { product: new_attributes }
        product.reload
        expect(product.price).to eq(20.0)
      end

      it "redirects to the product" do
        product = Product.create! valid_attributes
        patch factory_product_url(product), params: { product: new_attributes }
        product.reload
        expect(response).to redirect_to(factory_product_url(product))
      end
    end

    context "with invalid parameters" do
      it "renders a response with 422 status (i.e. to display the 'edit' template)" do
        product = Product.create! valid_attributes
        patch factory_product_url(product), params: { product: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested product" do
      product = Product.create! valid_attributes
      expect {
        delete factory_product_url(product)
      }.to change(Product, :count).by(-1)
    end

    it "redirects to the products list" do
      product = Product.create! valid_attributes
      delete factory_product_url(product)
      expect(response).to redirect_to(factory_products_url)
    end
  end
end
