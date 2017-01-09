require 'rails_helper'

RSpec.describe Factory::FormulasController, type: :controller do

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # FormulasController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  before :all do
    @element1 = create(:formula_element)
    @element2 = create(:formula_element)
    @valid_attributes = {
      abrasive: 'OA',
      grain: '20.3',
      hardness: 'R',
      porosity: '6',
      alloy: 'BAK',
      formula_items_attributes: [
        {
          formula_element_id: @element1.id,
          proportion: 50.0
        },
        {
          formula_element_id: @element2.id,
          proportion: 50.0
        }
      ]
    }

    @invalid_attributes = {
      abrasive: 'OA',
      grain: '20.3',
      hardness: 'R',
      porosity: '6',
      alloy: 'BAK',
      formula_items_attributes: [
        {
          formula_element_id: @element1.id,
          proportion: 50.0
        }
      ]
    }
  end

  describe "GET #index" do
    it "assigns all factory_formulas as @factory_formulas" do
      formula = Formula.create! @valid_attributes
      get :index, params: {}, session: valid_session
      expect(assigns(:formulas)).to eq([formula])
    end
  end

  describe "GET #show" do
    it "assigns the requested factory_formula as @factory_formula" do
      formula = Formula.create! @valid_attributes
      get :show, params: {id: formula.to_param}, session: valid_session
      expect(assigns(:formula)).to eq(formula)
    end
  end

  describe "GET #new" do
    it "assigns a new factory_formula as @factory_formula" do
      get :new, params: {}, session: valid_session
      expect(assigns(:formula)).to be_a_new(Formula)
    end
  end

  describe "GET #edit" do
    it "assigns the requested factory_formula as @factory_formula" do
      formula = Formula.create! @valid_attributes
      get :edit, params: {id: formula.to_param}, session: valid_session
      expect(assigns(:formula)).to eq(formula)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Formula" do
        expect {
          post :create, params: {formula: @valid_attributes}, session: valid_session
        }.to change(Formula, :count).by(1)
      end

      it "assigns a newly created factory_formula as @factory_formula" do
        post :create, params: {formula: @valid_attributes}, session: valid_session
        expect(assigns(:formula)).to be_a(Formula)
        expect(assigns(:formula)).to be_persisted
      end

      it "redirects to the created factory_formula" do
        post :create, params: {formula: @valid_attributes}, session: valid_session
        expect(response).to redirect_to(factory_formula_path(Formula.last))
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved factory_formula as @factory_formula" do
        post :create, params: {formula: @invalid_attributes}, session: valid_session
        expect(assigns(:formula)).to be_a_new(Formula)
      end

      it "re-renders the 'new' template" do
        post :create, params: {formula: @invalid_attributes}, session: valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      before :all do
        @formula = Formula.create! @valid_attributes.merge(abrasive: 'OAK')
        @new_attributes = {
          formula_items_attributes: [
            {
              id: @formula.formula_items.first.id,
              formula_element_id: @element2.id,
              proportion: 10.0
            },
            {
              id: @formula.formula_items.last.id,
              formula_element_id: @element1.id,
              proportion: 90.0
            }
          ]
        }
      end

      before :each do
        @formula.reload
      end

      it "updates the requested factory_formula" do
        put :update, params: {id: @formula.to_param, formula: @new_attributes}, session: valid_session
        @formula.reload
        expect(@formula.formula_items.last.proportion).to eq(90.0)
      end

      it "assigns the requested factory_formula as @factory_formula" do
        put :update, params: {id: @formula.to_param, formula: @valid_attributes}, session: valid_session
        expect(assigns(:formula)).to eq(@formula)
      end

      it "redirects to the factory_formula" do
        put :update, params: {id: @formula.to_param, formula: @new_attributes}, session: valid_session
        expect(response).to redirect_to(factory_formula_path(@formula))
      end
    end

    context "with invalid params" do
      it "assigns the factory_formula as @factory_formula" do
        formula = Formula.create! @valid_attributes
        put :update, params: {id: formula.to_param, formula: @invalid_attributes}, session: valid_session
        expect(assigns(:formula)).to eq(formula)
      end

      it "re-renders the 'edit' template" do
        formula = Formula.create! @valid_attributes
        put :update, params: {id: formula.to_param, formula: @invalid_attributes}, session: valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested factory_formula" do
      formula = Formula.create! @valid_attributes
      expect {
        delete :destroy, params: {id: formula.to_param}, session: valid_session
      }.to change(Formula, :count).by(-1)
    end

    it "redirects to the factory_formulas list" do
      formula = Formula.create! @valid_attributes
      delete :destroy, params: {id: formula.to_param}, session: valid_session
      expect(response).to redirect_to(factory_formulas_url)
    end
  end

end
