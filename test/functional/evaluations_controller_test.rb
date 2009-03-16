require 'test_helper'

class EvaluationsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:evaluations)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create evaluation" do
    assert_difference('Evaluation.count') do
      post :create, :evaluation => { }
    end

    assert_redirected_to evaluation_path(assigns(:evaluation))
  end

  test "should show evaluation" do
    get :show, :id => evaluations(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => evaluations(:one).to_param
    assert_response :success
  end

  test "should update evaluation" do
    put :update, :id => evaluations(:one).to_param, :evaluation => { }
    assert_redirected_to evaluation_path(assigns(:evaluation))
  end

  test "should destroy evaluation" do
    assert_difference('Evaluation.count', -1) do
      delete :destroy, :id => evaluations(:one).to_param
    end

    assert_redirected_to evaluations_path
  end
end
