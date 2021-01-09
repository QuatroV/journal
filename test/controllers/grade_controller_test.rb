# frozen_string_literal: true

require 'test_helper'

class GradeControllerTest < ActionDispatch::IntegrationTest
  test 'student wont see all student marks' do
    get '/students/sign_up'
    sign_in students(:one)
    get grade_show_all_grades_for_teacher_url
    assert_redirected_to root_url
  end

  test 'student will see his/her marks' do
    get '/students/sign_up'
    sign_in students(:one)
    get grade_show_all_grades_url
    assert :success
  end

  test 'teacher will see all marks' do
    get '/students/sign_up'
    sign_in students(:four)
    get grade_show_all_grades_for_teacher_url
    assert :success
  end

  test 'admin will see all marks' do
    get '/students/sign_up'
    sign_in students(:six)
    get grade_show_all_grades_for_teacher_url
    assert :success
  end
end
