require 'test_helper'

class ShortensControllerTest < ActionController::TestCase

  test "should get shortcode without lastseendate stats" do
    get(:stats, {'id' => "sone" })
    
    shorten = JSON.parse( @response.body )
    assert_equal 0, shorten['redirectcount']
    assert_equal "2013-01-15T10:41:24.000Z", shorten['startdate']
    assert_nil shorten['lastseendate']
    assert_response :success
  end
  
  test "should get shortcode with lastseendate stats" do
    get(:stats, {'id' => "stwo" })
    
    shorten = JSON.parse( @response.body )
    assert_equal 2, shorten['redirectcount']
    assert_equal "2014-05-15T08:45:16.000Z", shorten['startdate']
    assert_equal "2015-01-15T10:41:24.000Z", shorten['lastseendate']
    assert_response :success
  end
  
  test "should not get shortcode stats" do
    get(:stats, {'id' => "sthree" })
    assert_response :missing
  end
  
    test "should redirect one" do
    get(:show, {'id' => "sone" })
    assert_redirected_to "http://stackoverflow.com/questions/21269050/rails-yaml-fixture-specify-null-value"
    assert_response :redirect
  end
  
  test "should redirect two" do
    get(:show, {'id' => "stwo" })
    assert_redirected_to "http://stackoverflow.com"
    assert_response :redirect
  end
  
  test "should not get shortcode" do
    get(:show, {'id' => "12345" })
    assert_response :missing
  end
  
  test "should insert shortcode" do
    post :create, shorten: {url: "http://example2.com",shortcode: "example2"}
    shorten = JSON.parse( @response.body )
    assert_equal "example2", shorten['shortcode']
    assert_response :success
  end
  
  test "should insert shortcode with generated shortcode" do
    post :create, shorten: {url: "http://example3.com"}
    shorten = JSON.parse( @response.body )
    assert_match( /^[0-9a-zA-Z_]{6,}$/, shorten['shortcode'] )
    assert_response :success
  end
  
  test "should not insert shortcode missing url" do
    post :create, shorten: {shortcode: "example4"}
    assert_response(400)
  end
  
  test "should not insert shortcode regexp not matched" do
    post :create, shorten: {url: "http://example5.com", shortcode: "exa"}
    assert_response(422)
  end
  
  test "should not insert shortcode duplicated shortcode" do
    post :create, shorten: {url: "http://example6.com", shortcode: "sone"}
    assert_response(409)
  end
  
end
