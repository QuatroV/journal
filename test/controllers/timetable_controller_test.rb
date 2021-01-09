# frozen_string_literal: true

require 'test_helper'

class TimetableControllerTest < ActionDispatch::IntegrationTest
  test 'unauthorized user will be redirected to login page' do
    get root_url
    assert_redirected_to new_student_session_path
  end

  test 'authorized user will see the schedule' do
    get '/students/sign_up'
    sign_in students(:one)
    get root_url
    assert_response :success
  end
end
