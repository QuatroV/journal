# frozen_string_literal: true

require 'test_helper'

class SubjectControllerTest < ActionDispatch::IntegrationTest
  def setup
    get '/students/sign_up'
    sign_in students(:six)
  end

  test 'admin will see subject list' do
    get subject_show_all_subjects_url
    assert_response :success
  end

  test 'admin will add new subject' do
    assert_nil Subject.find_by(name: "PE")
    params_s = {"subject_name"=>"PE"}
    post subject_add_subject_url, params: params_s, xhr: true
    assert_response :success
    assert_not_nil Subject.find_by(name: "PE")
  end

  test 'admin wont add same subject' do
    assert_nil Subject.find_by(name: "PE")
    params_s = {"subject_name"=>"PE"}
    post subject_add_subject_url, params: params_s, xhr: true
    assert_response :success
    post subject_add_subject_url, params: params_s, xhr: true
    amount_of_subjects = Subject.where(name:"PE").count
    assert_equal 1, amount_of_subjects
  end

  test 'admin will delete subject' do
    params_s = {"name"=>"Math"}
    get subject_delete_subject_url, params: params_s, xhr: true
    assert_redirected_to root_url
    assert_nil Subject.find_by(name: "Math")
  end

end
