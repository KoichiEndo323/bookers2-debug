require "test_helper"

class ReletionshipsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get reletionships_create_url
    assert_response :success
  end

  test "should get destroy" do
    get reletionships_destroy_url
    assert_response :success
  end
end
