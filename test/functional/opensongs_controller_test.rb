require 'test_helper'

class OpensongsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:opensongs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create opensong" do
    assert_difference('Opensong.count') do
      post :create, :opensong => { }
    end

    assert_redirected_to opensong_path(assigns(:opensong))
  end

  test "should show opensong" do
    get :show, :id => opensongs(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => opensongs(:one).to_param
    assert_response :success
  end

  test "should update opensong" do
    put :update, :id => opensongs(:one).to_param, :opensong => { }
    assert_redirected_to opensong_path(assigns(:opensong))
  end

  test "should destroy opensong" do
    assert_difference('Opensong.count', -1) do
      delete :destroy, :id => opensongs(:one).to_param
    end

    assert_redirected_to opensongs_path
  end
end
