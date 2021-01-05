Rails.application.routes.draw do
  root 'grade#show'
  get 'grade/show_all_grades'
  get 'grade/show_all_grades_for_teacher'
  get 'grade/get_marks_for_class'
  get 'grade/delete_lesson'
  get 'grade/new_lesson'
  get 'grade/create_lesson'
  get 'grade/get_teachers'
  get 'grade/show_all_subjects'
  get 'grade/show_all_students'
  get 'grade/get_all_students'
  get 'grade/show_all_teachers'
  post 'grade/add_subject'
  get 'grade/delete_subject'
  post 'grade/create_lesson'
  post 'grade/update_grades'
  post 'grade/update_homework'
  get 'grade/show_lesson/:id', to: 'grade#show_lesson', as: 'show_lesson'
  get 'grade/show_timetable'
  devise_for :students
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
