require "test_helper"

class PresentationsControllerTest < ActionDispatch::IntegrationTest
  test "should get update" do
    get presentations_update_url
    assert_response :success
  end

  test "should get edit" do
    get presentations_edit_url
    assert_response :success
  end
end
