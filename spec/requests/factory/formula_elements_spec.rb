require 'rails_helper'

RSpec.describe "/factory/formula_elements", type: :request do
  let(:valid_attributes) {
    {
      current_stock: 10.0,
      infinite: false,
      min_stock: 20.0,
      name: "Calcium",
    }
  }

  let(:invalid_attributes) {
    {
      current_stock: "10",
      infinite: false,
      min_stock: "Hello",
      name: nil,
    }
  }

  before { sign_in create(:user) }

  describe "GET /index" do
    it "renders a successful response" do
      create(:formula_element) { valid_attributes }
      get factory_formula_elements_url
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      formula = create(:formula_element) { valid_attributes }
      get factory_formula_element_url(formula)
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_factory_formula_element_url
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "renders a successful response" do
      formula = create(:formula_element) { valid_attributes }
      get edit_factory_formula_element_url(formula)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Formula" do
        expect {
          post factory_formula_elements_url, params: { formula_element: valid_attributes }
        }.to change(FormulaElement, :count).by(1)
      end

      it "redirects to the created formula element" do
        post factory_formula_elements_url, params: { formula_element: valid_attributes }
        expect(response).to redirect_to(factory_formula_element_url(FormulaElement.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new FormulaElement" do
        expect {
          post factory_formula_elements_url, params: { formula_element: invalid_attributes }
        }.to change(FormulaElement, :count).by(0)
      end

      it "renders a response with 422 status (i.e. to display the 'new' template)" do
        post factory_formula_elements_url, params: { formula_element: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        {
          current_stock: 0.0,
          infinite: true,
          min_stock: 0.0,
          name: "Water",
        }
      }

      it "updates the requested formula element" do
        formula_element = create(:formula_element, **valid_attributes)
        patch factory_formula_element_url(formula_element), params: { formula_element: new_attributes }
        formula_element.reload
        expect(formula_element.name).to eq("Water")
      end

      it "redirects to the formula element" do
        formula_element = create(:formula_element, **valid_attributes)
        patch factory_formula_element_url(formula_element), params: { formula_element: new_attributes }
        formula_element.reload
        expect(response).to redirect_to(factory_formula_element_url(formula_element))
      end
    end

    context "with invalid parameters" do
      it "renders a response with 422 status (i.e. to display the 'edit' template)" do
        formula_element = create(:formula_element, **valid_attributes)
        patch factory_formula_element_url(formula_element), params: { formula_element: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "prevents duplicated names" do
        create(:formula_element, name: 'Dup1')
        formula_element2 = create(:formula_element, name: 'Dup2')
        patch factory_formula_element_url(formula_element2), params: { formula_element: { name: 'Dup1' } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested formula" do
      formula = create(:formula_element, **valid_attributes)
      expect {
        delete factory_formula_element_url(formula)
      }.to raise_error(RuntimeError, "Formula elements cannot be destroyed! They are part of the production history. Implement archiving instead.")
    end
  end
end
