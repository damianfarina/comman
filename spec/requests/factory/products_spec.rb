require 'rails_helper'

RSpec.describe "/factory/products", type: :request do
  let(:formula1) do
    create(
      :formula,
      :with_items,
      abrasive: "A",
      grain: "B",
      hardness: "C",
      porosity: "D",
      alloy: "E",
    )
  end
  let(:formula2) do
    create(
      :formula,
      :with_items,
      abrasive: "V",
      grain: "W",
      hardness: "X",
      porosity: "Y",
      alloy: "Z",
    )
  end
  let(:valid_attributes) {
    {
      current_stock: 5,
      productable_type: "ManufacturedProduct",
      productable_attributes: {
        formula_id: formula1.id,
        shape: "RR",
        size: "250x100x50",
        weight: 10.0,
        pressure: "G100",
      },
    }
  }

  let(:invalid_attributes) {
    {
      current_stock: "Nothing left",
      productable_type: "ManufacturedProduct",
      productable_attributes: {
        formula_id: formula1.id,
        shape: "RR",
        size: "150x100x50",
        weight: "HEAVY",
        pressure: "G100",
      },
    }
  }

  before { sign_in create(:user) }

  describe "GET /index" do
    let!(:product1) do
      create(
        :manufactured_productable,
        id: 1234,
        formula: formula1,
        pressure: "G100",
        shape: "RR",
        size: "250x100x50",
        weight: 10.0,
      )
    end
    let!(:product2) do
      create(
        :manufactured_productable,
        id: 5678,
        formula: formula2,
        shape: "SQ",
        pressure: "G120",
        size: "300x150x75",
        weight: 12.5,
      )
    end

    it "renders a successful response" do
      create(:manufactured_productable)
      get factory_products_url
      expect(response).to be_successful
    end

    context "sorting" do
      it "by formula name asc" do
        get factory_products_url, params: { q: { s: "productable_of_ManufacturedProduct_type_formula_name asc" } }, as: :json

        json_response = JSON.parse(response.body)
        expect(response).to be_successful
        expect(json_response.pluck("id")).to eq([ product1.id, product2.id ])
      end

      it "by formula name desc" do
        get factory_products_url, params: { q: { s: "productable_of_ManufacturedProduct_type_formula_name desc" } }, as: :json

        json_response = JSON.parse(response.body)
        expect(response).to be_successful
        expect(json_response.pluck("id")).to eq([ product2.id, product1.id ])
      end
    end

    context "with IdSearchQueryProcessor" do
      context "when params[:q] contains id_or_name_cont with #1234" do
        it "filters by ID" do
          get factory_products_url, params: { q: { "id_or_name_cont" => "#1234" } }, as: :json

          json_response = JSON.parse(response.body)
          expect(response).to be_successful
          expect(json_response.pluck("id")).to contain_exactly(1234)
        end
      end

      context "when params[:q] contains id_or_comments_cont with #5678" do
        it "filters by ID" do
          get factory_products_url, params: { q: { "id_or_comments_cont" => "#5678" } }, as: :json

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
      product = create(:manufactured_productable)
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
      product = create(:manufactured_productable)
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
        .and change(ManufacturedProduct, :count).by(1)
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
        .and change(ManufacturedProduct, :count).by(0)
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
          current_stock: 27,
          productable_attributes: {
            formula_id: formula1.id,
            shape: "OO",
          },
        }
      }

      it "updates the requested product" do
        product = create(:manufactured_productable)

        patch factory_product_url(product), params: { product: new_attributes }
        product.reload
        expect(product.current_stock).to eq(27)
        expect(product.productable.shape).to eq("OO")
        expect(product.productable.formula_id).to eq(formula1.id)
      end

      it "redirects to the product" do
        product = create(:manufactured_productable)
        patch factory_product_url(product), params: { product: new_attributes }
        product.reload
        expect(response).to redirect_to(factory_product_url(product))
      end
    end

    context "with invalid parameters" do
      it "renders a response with 422 status (i.e. to display the 'edit' template)" do
        product = create(:manufactured_productable)
        patch factory_product_url(product), params: { product: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested product" do
      product = create(:manufactured_productable)
      expect {
        delete factory_product_url(product)
      }.to change(Product, :count).by(-1)
      .and change(ManufacturedProduct, :count).by(-1)
    end

    it "redirects to the products list" do
      product = create(:manufactured_productable)
      delete factory_product_url(product)
      expect(response).to redirect_to(factory_products_url)
    end
  end
end
