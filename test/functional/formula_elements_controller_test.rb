require 'test_helper'

class FormulaElementsControllerTest < ActionController::TestCase
  setup do
    @formula_element = formula_elements(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:formula_elements)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create formula_element" do
    assert_difference('FormulaElement.count') do
      post :create, formula_element: @formula_element.attributes
    end

    assert_redirected_to formula_element_path(assigns(:formula_element))
  end

  test "should show formula_element" do
    get :show, id: @formula_element
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @formula_element
    assert_response :success
  end

  test "should update formula_element" do
    put :update, id: @formula_element, formula_element: @formula_element.attributes
    assert_redirected_to formula_element_path(assigns(:formula_element))
  end

  test "should destroy formula_element" do
    assert_difference('FormulaElement.count', -1) do
      delete :destroy, id: @formula_element
    end

    assert_redirected_to formula_elements_path
  end
end
