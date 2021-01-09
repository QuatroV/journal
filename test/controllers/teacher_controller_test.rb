# frozen_string_literal: true

require 'test_helper'

class TeacherControllerTest < ActionDispatch::IntegrationTest
  test 'admin will see all teachers' do
    get '/students/sign_up'
    sign_in students(:six)
    get '/teacher/show_all_teachers'
    assert_response :success
  end
end
