require 'test_helper'

class AssociationsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:associations)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create association" do
    assert_difference('Association.count') do
      post :create, :association => { }
    end

    assert_redirected_to association_path(assigns(:association))
  end

  test "should show association" do
    get :show, :id => associations(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => associations(:one).id
    assert_response :success
  end

  test "should update association" do
    put :update, :id => associations(:one).id, :association => { }
    assert_redirected_to association_path(assigns(:association))
  end

  test "should destroy association" do
    assert_difference('Association.count', -1) do
      delete :destroy, :id => associations(:one).id
    end

    assert_redirected_to associations_path
  end
end
