require 'rails_helper'

RSpec.describe "/factory/formulas", type: :request do
  let(:valid_attributes) {
    {
      abrasive: "AB",
      alloy: "Liga",
      grain: "A",
      hardness: "80",
      porosity: "Q",
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

  let!(:formula1) { create(:formula) }

  describe "GET /index" do
    it "renders a successful response" do
      Formula.create! valid_attributes
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
        expect(Formula.last.name).to eq("ABA80QLiga")
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
          abrasive: formula1.abrasive,
          alloy: formula1.alloy,
          grain: formula1.grain,
          hardness: formula1.hardness,
          porosity: formula1.porosity,
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
      formula = Formula.create! valid_attributes
      expect {
        delete factory_formula_url(formula)
      }.to change(Formula, :count).by(-1)
    end

    it "redirects to the formulas list" do
      formula = Formula.create! valid_attributes
      delete factory_formula_url(formula)
      expect(response).to redirect_to(factory_formulas_url)
    end
  end
end