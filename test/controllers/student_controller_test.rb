# frozen_string_literal: true

require 'test_helper'

class StudentControllerTest < ActionDispatch::IntegrationTest
  test 'student will see his/her marks' do
    get '/students/sign_up'
    sign_in students(:one)
    get '/grade/show_all_grades'
    assert_response :success
  end

  test 'admin will see all students' do
    get '/students/sign_up'
    sign_in students(:six)
    get '/student/show_all_students'
    assert_response :success
  end
end
