require 'test_helper'

class ParametersControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:parameters)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create parameter" do
    assert_difference('Parameter.count') do
      post :create, :parameter => { }
    end

    assert_redirected_to parameter_path(assigns(:parameter))
  end

  test "should show parameter" do
    get :show, :id => parameters(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => parameters(:one).to_param
    assert_response :success
  end

  test "should update parameter" do
    put :update, :id => parameters(:one).to_param, :parameter => { }
    assert_redirected_to parameter_path(assigns(:parameter))
  end

  test "should destroy parameter" do
    assert_difference('Parameter.count', -1) do
      delete :destroy, :id => parameters(:one).to_param
    end

    assert_redirected_to parameters_path
  end
end
