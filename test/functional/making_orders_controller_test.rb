require 'test_helper'

class MakingOrdersControllerTest < ActionController::TestCase
  setup do
    @making_order = making_orders(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:making_orders)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create making_order" do
    assert_difference('MakingOrder.count') do
      post :create, making_order: @making_order.attributes
    end

    assert_redirected_to making_order_path(assigns(:making_order))
  end

  test "should show making_order" do
    get :show, id: @making_order
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @making_order
    assert_response :success
  end

  test "should update making_order" do
    put :update, id: @making_order, making_order: @making_order.attributes
    assert_redirected_to making_order_path(assigns(:making_order))
  end

  test "should destroy making_order" do
    assert_difference('MakingOrder.count', -1) do
      delete :destroy, id: @making_order
    end

    assert_redirected_to making_orders_path
  end
end
