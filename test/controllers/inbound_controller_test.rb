require "test_helper"

class InboundControllerTest < ActionDispatch::IntegrationTest
  test "should get update" do
    get inbound_update_url
    assert_response :success
  end
end
