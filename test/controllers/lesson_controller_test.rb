# frozen_string_literal: true

require 'test_helper'

class LessonControllerTest < ActionDispatch::IntegrationTest
  def setup
    get '/students/sign_up'
  end

  test 'teacher will see the schedule' do
    sign_in students(:four)
    get root_url
    assert_response :success
  end

  test 'teacher will see his lesson page' do
    sign_in students(:four)
    get '/lesson/show_lesson/1'
    assert_response :success
  end

  test 'teacher wont see not own lesson' do
    sign_in students(:four)
    get '/lesson/show_lesson/2'
    assert_redirected_to root_url
  end

  test 'teacher will update homework on his lesson' do
    sign_in students(:four)
    old_homework = Lesson.find_by(id: 1).homework
    new_homework = { 'updated_homework' => 'HT', 'updated_lesson' => '1', 'id' => '1' }
    post lesson_update_homework_url(new_homework), xhr: true
    assert_response :success
    new_homework = Lesson.find_by(id: 1).homework
    assert_not_equal old_homework, new_homework
  end

  test 'teacher will update marks on his lesson' do
    sign_in students(:four)
    old_mark = Grade.find_by(lesson_id: 1, student_id: 1).value
    new_grades = { 'updated_grades' => '{"1":"2","2":"3"}', 'updated_lesson' => '1' }
    post lesson_update_grades_url, params: new_grades, as: :json, xhr: true
    assert_response :success
    new_mark = Grade.find_by(lesson_id: 1, student_id: 1).value
    assert_not_equal old_mark, new_mark
  end

  test 'admin will see any lesson' do
    sign_in students(:six)
    Lesson.all.each do |lesson|
      get '/lesson/show_lesson/' + lesson.id.to_s
      assert_response :success
    end
  end

  test 'admin will delete lesson' do
    sign_in students(:six)
    assert_not_nil Lesson.find_by(id: 1)
    params_s = { 'chosen_lesson' => '1' }
    get lesson_delete_lesson_url, params: params_s
    assert_redirected_to root_url
    deleted_lesson = Lesson.find_by(id: 1)
    assert_nil deleted_lesson
  end

  test 'admin will create lesson' do
    sign_in students(:six)
    assert_nil Lesson.find_by(day: '05.01.2021', pos: '5')
    params_s = { 'day' => '2021-01-05', 'pos' => '5', 'subject' => 'Math', 'homework' => 'HT', 'classnum' => '7', 'classlet' => 'A', 'teacher_id' => '4' }
    post lesson_create_lesson_url, params: params_s, as: :json, xhr: true
    new_lesson = Lesson.find_by(day: '05.01.2021', pos: '5')
    assert_not_nil new_lesson
  end

  test 'student wont see lesson page with marks' do
    get '/students/sign_up'
    sign_in students(:one)
    get '/lesson/show_lesson/2'
    assert_redirected_to root_url
  end
end
