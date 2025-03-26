require 'rails_helper'

RSpec.describe "/office/products", type: :request do
  let(:supplier1) { create(:supplier) }
  let(:supplier2) { create(:supplier) }
  let(:valid_attributes) {
    {
      current_stock: 5,
      max_stock: 10,
      min_stock: 5,
      name: "Product Name",
      price: 14.0,
      supplier_id: supplier1.id,
      supplier_products_attributes: [
        {
          supplier_id: supplier1.id,
          price: 14.0,
        },
        {
          supplier_id: supplier2.id,
          price: 16.0,
        },
      ],
    }
  }

  let(:invalid_attributes) {
    {
      current_stock: "Nothing left",
      max_stock: "Ten",
      min_stock: "Five",
      name: nil,
      supplier_products_attributes: [
        {
          supplier_id: supplier1.id,
          price: 14.0,
        },
        {
          supplier_id: supplier1.id,
          price: 20.0,
        },
      ],
    }
  }

  before { sign_in create(:user) }

  describe "GET /index" do
    it "renders a successful response" do
      create(:purchased_productable)
      get office_products_url
      expect(response).to be_successful
    end

    context "with IdSearchQueryProcessor" do
      let!(:product1) do
        create(
          :purchased_productable,
          id: 1234,
          name: "Purchase One",
        )
      end
      let!(:product2) do
        create(
          :purchased_productable,
          id: 5678,
          name: "Free Two",
        )
      end
      let!(:product3) do
        create(
          :manufactured_productable,
          id: 6789,
          name: "Manufactured Three",
        )
      end

      context "when params[:q] contains id_or_name_cont with #1234" do
        it "filters by ID" do
          get office_products_url, params: { q: { "id_or_name_cont" => "#1234" } }, as: :json

          json_response = JSON.parse(response.body)
          expect(response).to be_successful
          expect(json_response.pluck("name")).to eq([ "Purchase One" ])
        end
      end

      context "when params[:q] contains id_or_comments_cont with #5678" do
        it "filters by ID" do
          get office_products_url, params: { q: { "id_or_comments_cont" => "#5678" } }, as: :json

          json_response = JSON.parse(response.body)
          expect(response).to be_successful
          expect(json_response.pluck("name")).to eq([ "Free Two" ])
        end
      end

      context "when params[:q] does not contain any id_or_* keys" do
        it "returns Purchase products" do
          get office_products_url, params: { q: { "name_cont" => "Purchase" } }, as: :json

          json_response = JSON.parse(response.body)
          expect(response).to be_successful
          expect(json_response.pluck("id")).to match_array([ product1.id ])
        end
      end

      context "when params[:q] contains id_or_* keys but the value is missing the id" do
        it "returns no products" do
          get office_products_url, params: { q: { "id_or_name_cont" => "1234" } }, as: :json

          json_response = JSON.parse(response.body)
          expect(response).to be_successful
          expect(json_response.pluck("id")).to match_array([])
        end
      end
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      product = create(:purchased_productable)
      get office_product_url(product)
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_office_product_url
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "renders a successful response" do
      product = create(:purchased_productable)
      get edit_office_product_url(product)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Product" do
        expect {
          post office_products_url, params: { product: valid_attributes }
        }.to change(Product, :count).by(1)
        .and change(PurchasedProduct, :count).by(1)
      end

      it "redirects to the created product" do
        post office_products_url, params: { product: valid_attributes }
        expect(response).to redirect_to(office_product_url(Product.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Product" do
        expect {
          post office_products_url, params: { product: invalid_attributes }
        }.to change(Product, :count).by(0)
        .and change(PurchasedProduct, :count).by(0)
      end

      it "renders a response with 422 status (i.e. to display the 'new' template)" do
        post office_products_url, params: { product: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_supplier) { create(:supplier) }
      let(:new_attributes) {
        {
          name: "New Product Name",
          supplier_products_attributes: [
            { supplier_id: new_supplier.id, price: 24.0 },
          ],
        }
      }

      it "updates the requested product" do
        product = create(:purchased_productable)
        patch office_product_url(product), params: { product: new_attributes }
        product.reload
        expect(product.name).to eq("New Product Name")
        expect(product.supplier_products.first.supplier_id).to eq(new_supplier.id)
        expect(product.supplier_products.first.price).to eq(24.0)
      end

      it "redirects to the product" do
        product = create(:purchased_productable)
        patch office_product_url(product), params: { product: new_attributes }
        product.reload
        expect(response).to redirect_to(office_product_url(product))
      end
    end

    context "with invalid parameters" do
      it "renders a response with 422 status (i.e. to display the 'edit' template)" do
        product = create(:purchased_productable)
        patch office_product_url(product), params: { product: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "productable is a ManufacturedProduct" do
      it "updates manufactured product allowed attributes" do
        product = create(:manufactured_productable)
        original_name = product.name
        original_formula_id = product.productable.formula_id
        original_pressure = product.productable.pressure
        original_shape = product.productable.shape
        original_size = product.productable.size
        original_weight = product.productable.weight

        patch office_product_url(product), params: {
          product: {
            current_stock: 1,
            comments: "New comments",
            max_stock: 3,
            min_stock: 2,
            name: "not allowed",
            price: 66.6,
            productable_attributes: {
              id: product.productable.id,
              formula_id: 4,
              pressure: "not allowed",
              shape: "not allowed",
              size: "not allowed",
              weight: "not allowed",
            },
          },
        }
        product.reload
        expect(product.current_stock).to eq(1)
        expect(product.comments.body.to_plain_text).to eq("New comments")
        expect(product.max_stock).to eq(3)
        expect(product.min_stock).to eq(2)
        expect(product.name).to eq(original_name)
        expect(product.price).to eq(66.6)
        expect(product.productable.formula_id).to eq(original_formula_id)
        expect(product.productable.pressure).to eq(original_pressure)
        expect(product.productable.shape).to eq(original_shape)
        expect(product.productable.size).to eq(original_size)
        expect(product.productable.weight).to eq(original_weight)
      end

      it "updates purchased product allowed attributes" do
        product = create(:purchased_productable)

        patch office_product_url(product), params: {
          product: {
            current_stock: 1,
            comments: "New comments",
            max_stock: 3,
            min_stock: 2,
            name: "New Name",
            price: 66.6,
            supplier_id: supplier1.id,
            supplier_products_attributes: [
              {
                supplier_id: supplier1.id,
                price: 46.6,
                code: "ABC123",
              },
            ],
          },
        }

        product.reload
        expect(product.current_stock).to eq(1)
        expect(product.comments.body.to_plain_text).to eq("New comments")
        expect(product.max_stock).to eq(3)
        expect(product.min_stock).to eq(2)
        expect(product.name).to eq("New Name")
        expect(product.price).to eq(66.6)
        expect(product.supplier_id).to eq(supplier1.id)
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested product" do
      product = create(:purchased_productable)
      expect {
        delete office_product_url(product)
      }.to change(Product, :count).by(-1)
      .and change(PurchasedProduct, :count).by(-1)
    end

    it "redirects to the products list" do
      product = create(:purchased_productable)
      delete office_product_url(product)
      expect(response).to redirect_to(office_products_url)
    end
  end
end
