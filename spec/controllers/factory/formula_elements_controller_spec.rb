require 'rails_helper'

RSpec.describe Factory::FormulaElementsController, type: :controller do

  let(:valid_session) { {} }

  let(:valid_attributes) do
    {
      name: 'Name',
      min_stock: 10,
      current_stock: 15
    }
  end

  let(:invalid_attributes) do
    {
      min_stock: 0,
      current_stock: 15
    }
  end

  describe "GET index" do
    it "assigns all elements as @formula_elements" do
      element = FormulaElement.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(assigns(:formula_elements)).to eq([element])
    end
  end

  describe "GET show" do
    it "assigns the requested element as @formula_element" do
      element = FormulaElement.create! valid_attributes
      get :show, params: {id: element.to_param}, session: valid_session
      expect(assigns(:formula_element)).to eq(element)
    end
  end

  describe "GET new" do
    it "assigns a new element as @formula_element" do
      get :new, params: {}, session: valid_session
      expect(assigns(:formula_element)).to be_a_new(FormulaElement)
    end
  end

  describe "GET edit" do
    it "assigns the requested element as @formula_element" do
      element = FormulaElement.create! valid_attributes
      get :edit, params: {id: element.to_param}, session: valid_session
      expect(assigns(:formula_element)).to eq(element)
    end
  end

  describe "POST create" do
    context "with valid params" do
      it "creates a new element" do
        expect {
          post :create, params: {formula_element: valid_attributes}, session: valid_session
        }.to change(FormulaElement, :count).by(1)
      end

      it "assigns a newly created element as @formula_element" do
        post :create, params: {formula_element: valid_attributes}, session: valid_session
        expect(assigns(:formula_element)).to be_a(FormulaElement)
        expect(assigns(:formula_element)).to be_persisted
      end

      it "redirects to the created element" do
        post :create, params: {formula_element: valid_attributes}, session: valid_session
        expect(response).to redirect_to(factory_formula_element_path(FormulaElement.last))
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved element as @formula_element" do
        post :create, params: {formula_element: invalid_attributes}, session: valid_session
        expect(assigns(:formula_element)).to be_a_new(FormulaElement)
      end

      it "re-renders the 'new' template" do
        post :create, params: {formula_element: invalid_attributes}, session: valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT update" do
    context "with valid params" do
      let(:new_attributes) do
        {
          current_stock: 100
        }
      end

      it "updates the requested element" do
        element = FormulaElement.create! valid_attributes
        put :update,
          params: {id: element.to_param, formula_element: new_attributes},
          session: valid_session
        element.reload
        expect(element.current_stock).to eq(100)
      end

      it "assigns the requested element as @formula_element" do
        element = FormulaElement.create! valid_attributes
        put :update,
          params: {id: element.to_param, formula_element: valid_attributes},
          session: valid_session
        expect(assigns(:formula_element)).to eq(element)
      end

      it "redirects to the element" do
        element = FormulaElement.create! valid_attributes
        put :update,
          params: {id: element.to_param, formula_element: valid_attributes},
          session: valid_session
        expect(response).to redirect_to(factory_formula_element_path(element))
      end
    end

    context "with invalid params" do
      it "assigns the element as @formula_element" do
        element = FormulaElement.create! valid_attributes
        put :update,
          params: {id: element.to_param, formula_element: invalid_attributes},
          session: valid_session
        expect(assigns(:formula_element)).to eq(element)
      end

      it "re-renders the 'edit' template" do
        element = FormulaElement.create! valid_attributes
        put :update,
          params: {id: element.to_param, formula_element: invalid_attributes},
          session: valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested element" do
      element = FormulaElement.create! valid_attributes
      expect {
        delete :destroy, params: {id: element.to_param}, session: valid_session
      }.to change(FormulaElement, :count).by(-1)
    end

    it "redirects to the elements list" do
      element = FormulaElement.create! valid_attributes
      delete :destroy, params: {id: element.to_param}, session: valid_session
      expect(response).to redirect_to(factory_formula_elements_url)
    end
  end

end
