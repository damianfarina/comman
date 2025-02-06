require 'rails_helper'

RSpec.describe "/factory/formulas", type: :request do
  let(:valid_attributes) {
    {
      abrasive: "ABC",
      alloy: "Liga",
      grain: "A",
      hardness: "80",
      porosity: "Q",
      formula_items_attributes: [
        {
          formula_element_id: create(:formula_element).id,
          proportion: 50,
        },
        {
          formula_element_id: create(:formula_element).id,
          proportion: 50,
        },
      ],
    }
  }

  let(:invalid_attributes) {
    {
      abrasive: nil,
      alloy: "Liga",
      grain: "A",
      hardness: "80",
      porosity: "Q",
    }
  }

  let!(:formula) { create(:formula, :with_items) }

  before { sign_in create(:user) }

  describe "GET /index" do
    it "renders a successful response" do
      create(:formula, :with_items)
      get factory_formulas_url
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      formula = Formula.create! valid_attributes
      get factory_formula_url(formula)
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_factory_formula_url
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "renders a successful response" do
      formula = Formula.create! valid_attributes
      get edit_factory_formula_url(formula)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Formula" do
        expect {
          post factory_formulas_url, params: { formula: valid_attributes }
        }.to change(Formula, :count).by(1)
        expect(Formula.last.name).to eq("ABCA80QLiga")
      end

      it "redirects to the created formula" do
        post factory_formulas_url, params: { formula: valid_attributes }
        expect(response).to redirect_to(factory_formula_url(Formula.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Formula" do
        expect {
          post factory_formulas_url, params: { formula: invalid_attributes }
        }.to change(Formula, :count).by(0)
      end

      it "tries to duplicate " do
        duplicated_attributes = {
          abrasive: formula.abrasive,
          alloy: formula.alloy,
          grain: formula.grain,
          hardness: formula.hardness,
          porosity: formula.porosity,
        }
        expect {
          post factory_formulas_url, params: { formula: duplicated_attributes }
        }.to change(Formula, :count).by(0)
      end

      it "renders a response with 422 status (i.e. to display the 'new' template)" do
        post factory_formulas_url, params: { formula: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        {
          abrasive: "NEW",
          alloy: "Liga",
          grain: "A",
          hardness: "80",
          porosity: "Q",
        }
      }

      it "updates the requested formula" do
        formula = Formula.create! valid_attributes
        patch factory_formula_url(formula), params: { formula: new_attributes }
        formula.reload
        expect(formula.name).to eq("NEWA80QLiga")
      end

      it "redirects to the formula" do
        formula = Formula.create! valid_attributes
        patch factory_formula_url(formula), params: { formula: new_attributes }
        formula.reload
        expect(response).to redirect_to(factory_formula_url(formula))
      end
    end

    context "with invalid parameters" do
      it "renders a response with 422 status (i.e. to display the 'edit' template)" do
        formula = Formula.create! valid_attributes
        patch factory_formula_url(formula), params: { formula: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested formula" do
      expect {
        delete factory_formula_url(formula)
      }.to change(Formula, :count).by(-1)
    end

    it "redirects to the formulas list" do
      delete factory_formula_url(formula)
      expect(response).to redirect_to(factory_formulas_url)
    end
  end
end
