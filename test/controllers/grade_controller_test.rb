require 'test_helper'

class GradeControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get grade_show_url
    assert_response :success
  end

  test "should get edit" do
    get grade_edit_url
    assert_response :success
  end

end
