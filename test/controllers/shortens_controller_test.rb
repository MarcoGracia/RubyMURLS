require 'test_helper'

class ShortensControllerTest < ActionController::TestCase
  setup do
    @shorten = shortens(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:shortens)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create shorten" do
    assert_difference('Shorten.count') do
      post :create, shorten: { lastseendate: @shorten.lastseendate, redirectcount: @shorten.redirectcount, shortcode: @shorten.shortcode, startdate: @shorten.startdate, url: @shorten.url }
    end

    assert_redirected_to shorten_path(assigns(:shorten))
  end

  test "should show shorten" do
    get :show, id: @shorten
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @shorten
    assert_response :success
  end

  test "should update shorten" do
    patch :update, id: @shorten, shorten: { lastseendate: @shorten.lastseendate, redirectcount: @shorten.redirectcount, shortcode: @shorten.shortcode, startdate: @shorten.startdate, url: @shorten.url }
    assert_redirected_to shorten_path(assigns(:shorten))
  end

  test "should destroy shorten" do
    assert_difference('Shorten.count', -1) do
      delete :destroy, id: @shorten
    end

    assert_redirected_to shortens_path
  end
end
