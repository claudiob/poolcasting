require 'test_helper'

class CooccurrencesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:cooccurrences)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create cooccurrence" do
    assert_difference('Cooccurrence.count') do
      post :create, :cooccurrence => { }
    end

    assert_redirected_to cooccurrence_path(assigns(:cooccurrence))
  end

  test "should show cooccurrence" do
    get :show, :id => cooccurrences(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => cooccurrences(:one).to_param
    assert_response :success
  end

  test "should update cooccurrence" do
    put :update, :id => cooccurrences(:one).to_param, :cooccurrence => { }
    assert_redirected_to cooccurrence_path(assigns(:cooccurrence))
  end

  test "should destroy cooccurrence" do
    assert_difference('Cooccurrence.count', -1) do
      delete :destroy, :id => cooccurrences(:one).to_param
    end

    assert_redirected_to cooccurrences_path
  end
end
