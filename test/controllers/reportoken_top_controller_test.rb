require 'test_helper'

class ReportokenTopControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
    get reportoken_top_home_url
    assert_response :success
  end

  test "should get help" do
    get reportoken_top_help_url
    assert_response :success
  end

end
