# frozen_string_literal: true

class TimetableController < ApplicationController
  def show; end

  # Returning timetable
  def show_timetable
    chosen_year = params[:chosen_week][0..3].to_i
    chosen_week = params[:chosen_week][-2..].to_i
    beginning_of_current_week = Date.commercial(chosen_year, chosen_week)
    result = []
    beginning_of_current_week.step(beginning_of_current_week.end_of_week, 1) do |day|
      if current_student.role == 'Student'
        result.push(daily_timetable_with_marks(day))
      elsif current_student.role.include? 'Teacher'
        result.push(daily_timetable_without_marks(day))
      elsif current_student.role == 'Administrator'
        result.push(daily_timetable_min(day))
      end
    end
    respond_to do |format|
      format.html
      format.json do
        render json:
          { result: result }
      end
    end
  end

  private

  def daily_timetable_with_marks(date)
    num = current_student.classnum
    let = current_student.classlet
    lesson_amount = Lesson.where(day: date, classnum: num, classlet: let).count
    today_lessons = Lesson.order(pos: :asc).where(day: date, classnum: num, classlet: let)
    unless Lesson.find_by(day: date, classnum: num, classlet: let).blank?
      timetable = today_lessons.select(:id, :pos, :subject, :homework).to_a
    end
    current_user_marks = []
    (1..lesson_amount).each do |i|
      current_mark = today_lessons[i - 1].grades.find_by(student_id: current_student.id)
      if current_mark
        current_user_marks.push(current_mark.value)
      else
        current_user_marks.push(' ')
      end
    end
    # Returning teachers
    teachers = []
    today_lessons.each_with_index do |lesson, i|
      teachers[i] = Student.find_by(id: lesson.teacher_id).name
    end
    [timetable, current_user_marks, teachers]
  end

  def daily_timetable_without_marks(date)
    c_teacher_id = current_student.id
    today_lessons = Lesson.order(pos: :asc, classnum: :asc, classlet: :asc).where(day: date, teacher_id: c_teacher_id)
    unless Lesson.find_by(day: date).blank?
      timetable = today_lessons.select(:id, :pos, :subject, :homework, :classnum, :classlet).to_a
    end
  end

  def daily_timetable_min(date)
    num = params[:chosen_classnum]
    let = params[:chosen_classlet]
    today_lessons = Lesson.order(pos: :asc, classnum: :asc, classlet: :asc).where(day: date, classnum: num, classlet: let)
    unless Lesson.find_by(day: date, classnum: num, classlet: let).blank?
      timetable = today_lessons.select(:id, :pos, :subject, :homework).to_a
    end
    teachers = []
    today_lessons.each_with_index do |lesson, i|
      teachers[i] = Student.find_by(id: lesson.teacher_id).name
    end
    [timetable, teachers]
  end
end
