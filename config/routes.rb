Rails.application.routes.draw do
  # timetable
    root 'timetable#show'
    get 'timetable/show_timetable'
  # grade
    get 'grade/show_all_grades'
    get 'grade/show_all_grades_for_teacher'
    get 'grade/get_marks_for_class'
  # teacher
    get 'teacher/show_all_teachers'
    get 'teacher/get_teachers'
  # student
    get 'student/show_all_students'
    get 'student/get_all_students'
  # lesson
    get 'lesson/new_lesson'
    post 'lesson/create_lesson'
    get 'lesson/delete_lesson'
    post 'lesson/update_grades'
    post 'lesson/update_homework'
    get 'lesson/show_lesson/:id', to: 'lesson#show_lesson', as: 'show_lesson'
  # subject
    get 'subject/show_all_subjects'
    post 'subject/add_subject'
    get 'subject/delete_subject'
  devise_for :students
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
