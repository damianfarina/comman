require 'test_helper'

class DeliveryNotesControllerTest < ActionController::TestCase
  setup do
    @delivery_note = delivery_notes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:delivery_notes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create delivery_note" do
    assert_difference('DeliveryNote.count') do
      post :create, delivery_note: { client_id: @delivery_note.client_id, comments: @delivery_note.comments }
    end

    assert_redirected_to delivery_note_path(assigns(:delivery_note))
  end

  test "should show delivery_note" do
    get :show, id: @delivery_note
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @delivery_note
    assert_response :success
  end

  test "should update delivery_note" do
    put :update, id: @delivery_note, delivery_note: { client_id: @delivery_note.client_id, comments: @delivery_note.comments }
    assert_redirected_to delivery_note_path(assigns(:delivery_note))
  end

  test "should destroy delivery_note" do
    assert_difference('DeliveryNote.count', -1) do
      delete :destroy, id: @delivery_note
    end

    assert_redirected_to delivery_notes_path
  end
end
