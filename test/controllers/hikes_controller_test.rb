require "test_helper"

class HikesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get hikes_index_url
    assert_response :success
  end

  test "should get show" do
    get hikes_show_url
    assert_response :success
  end

  test "should get new" do
    get hikes_new_url
    assert_response :success
  end

  test "should get create" do
    get hikes_create_url
    assert_response :success
  end

  test "should get edit" do
    get hikes_edit_url
    assert_response :success
  end

  test "should get update" do
    get hikes_update_url
    assert_response :success
  end

  test "should get destroy" do
    get hikes_destroy_url
    assert_response :success
  end
end
