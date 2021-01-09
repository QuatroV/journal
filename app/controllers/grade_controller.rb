# frozen_string_literal: true

class GradeController < ApplicationController
  before_action :current_student_is_student, only: [:show_all_grades]
  before_action :current_student_is_teacher, only: %i[show_all_grades_for_teacher get_marks_for_class]

  def show_all_grades; end

  def show_all_grades_for_teacher; end

  def get_marks_for_class
    current_classnum = params[:chosen_class].tr('^0-9', '')
    current_classlet = params[:chosen_class].last
    current_teacher_lessons_ids = Lesson.where(teacher_id: current_student.id).to_a.map(&:id)
    result = []
    Student.where(classnum: current_classnum, classlet: current_classlet).each do |stud|
      found_marks = Grade.where(student_id: stud.id, lesson_id: current_teacher_lessons_ids).to_a.map(&:value)
      el = { name: stud.name, marks: found_marks }
      result.push(el)
    end
    result.insert(0, params[:chosen_class])
    respond_to do |format|
      format.html
      format.json do
        render json:
          { result: result }
      end
    end
  end
end
