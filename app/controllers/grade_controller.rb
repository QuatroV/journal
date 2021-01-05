class GradeController < ApplicationController
  skip_before_action :verify_authenticity_token, :only => [:update_grades, :update_homework, :create_lesson]
  before_action :current_student_is_student?, :only => [:show_all_grades]
  before_action :current_student_is_teacher?, :only => [:show_all_grades_for_teacher, :get_marks_for_class]
  before_action :current_student_is_admin?, :only => [:show_all_subjects, :delete_lesson, :new_lesson, :create_lesson, :get_teachers, :add_subject, :delete_subject, :show_all_students, :show_all_teachers, :get_all_students]
  before_action :current_student_is_teacher_or_admin?, :only => [:show_lesson, :update_grades, :update_homework]
  before_action :correct_subject?, :only => [:show_lesson, :update_grades, :update_homework]

  def show
  end

  def show_lesson
  end

  def update_grades
    updated_hash = JSON.parse params[:updated_grades]
    updated_lesson_id = params[:updated_lesson]
    old_marks = Lesson.find_by(id: updated_lesson_id).grades
    updated_hash.each do |current_student_id, new_mark|
      old_mark = old_marks.find_by(student_id: current_student_id)
      if old_mark.blank? then
        if new_mark != "" then
          #Adding new grade
          Grade.create(value: new_mark, student_id: current_student_id, lesson_id: updated_lesson_id)
        end
      else
        if new_mark == ""
          #Deleting grade
          old_mark.destroy
        elsif new_mark != old_mark
          #Updating grade
          old_mark.update(value: new_mark)
        end
      end
    end
  end

  def update_homework
    updated_lesson = params[:updated_lesson]
    old_lesson = Lesson.find_by(id: params[:updated_lesson])
    if old_lesson.homework != params[:updated_homework]
      old_lesson.update(homework: params[:updated_homework])
    end
  end

  #Returning timetable 
  def show_timetable
    chosen_year, chosen_week = params[:chosen_week][0..3].to_i, params[:chosen_week][-2..-1].to_i
    beginning_of_current_week = Date.commercial(chosen_year, chosen_week)
    result = []
    beginning_of_current_week.step(beginning_of_current_week.end_of_week, 1) do |day|
      if current_student.role == "Student" then
        result.push(daily_timetable_with_marks(day))
      elsif current_student.role.include? "Teacher" then 
        result.push(daily_timetable_without_marks(day))
      elsif current_student.role == "Administrator" then
        result.push(daily_timetable_min(day))
      end
    end
    respond_to do |format|
      format.html
      format.json do
        render json:
          {result: result}
      end
    end
  end

  def show_all_grades
  end

  def show_all_grades_for_teacher
  end

  def get_marks_for_class
    current_classnum = params[:chosen_class].tr('^0-9', '') 
    current_classlet = params[:chosen_class].last
    current_teacher_lessons_ids = Lesson.where(teacher_id: current_student.id).to_a.map{|el| el.id}
    result = []
    Student.where(classnum: current_classnum, classlet: current_classlet).each do |stud|
      found_marks = Grade.where(student_id: stud.id, lesson_id: current_teacher_lessons_ids).to_a.map{|el| el.value}
      el = {name: stud.name, marks: found_marks}
      result.push(el) 
    end
    result.insert(0, params[:chosen_class])
    respond_to do |format|
      format.html
      format.json do
        render json:
          {result: result}
      end
    end
  end

  def delete_lesson
    Grade.where(lesson_id: params[:chosen_lesson]).destroy_all
    Lesson.find_by(id: params[:chosen_lesson]).destroy
    redirect_to root_url
  end
  
  def new_lesson
  end

  def create_lesson
    Lesson.create(day: params[:day], pos: params[:pos], subject: params[:subject], teacher_id: params[:teacher_id], homework: params[:homework], classnum: params[:classnum], classlet: params[:classlet])
  end
  
  def get_teachers
    kind_of_teacher = params[:subject] + " Teacher"
    result = []
    Student.where(role: kind_of_teacher).to_a.map do |el|
      stud = []
      stud.push(el.name, el.id)
      result.push(stud)
    end
    respond_to do |format|
      format.html
      format.json do
        render json:
          {result: result}
      end
    end
  end

  def show_all_subjects

  end

  def add_subject
    Subject.create(name: params[:subject_name])
    redirect_back(fallback_location: root_path)
  end

  def delete_subject
    Subject.find_by(name: params[:name]).destroy
    redirect_back(fallback_location: root_path)
  end

  def show_all_students
  end 

  def show_all_teachers
  end

  def get_all_students
    current_classnum = params[:chosen_class].tr('^0-9', '') 
    current_classlet = params[:chosen_class].last
    result = Student.where(classnum: current_classnum, classlet: current_classlet).to_a.map{|el| el.name}
    respond_to do |format|
      format.html
      format.json do
        render json:
          {result: result}
      end
    end
  end

  private
    
  def daily_timetable_with_marks(date)
    lesson_amount = Lesson.where(day: date, classnum: current_student.classnum, classlet: current_student.classlet).count
    today_lessons = Lesson.order(pos: :asc).where(day: date, classnum: current_student.classnum, classlet: current_student.classlet)
    timetable = today_lessons.select(:id, :pos, :subject, :homework).to_a unless Lesson.find_by(day: date, classnum: current_student.classnum, classlet: current_student.classlet).blank?
    current_user_marks = []
    for i in 1..lesson_amount
      current_mark = today_lessons[i-1].grades.find_by(student_id: current_student.id)
      if current_mark then
        current_user_marks.push(current_mark.value)
      else 
        current_user_marks.push(" ")
      end
    end
    #Returning teachers 
    teachers = []
    today_lessons.each_with_index do |lesson, i|
      teachers[i] = Student.find_by(id: lesson.teacher_id).name
    end
    return timetable, current_user_marks, teachers
  end

  def daily_timetable_without_marks(date)
    current_teacher_id = current_student.id
    today_lessons = Lesson.order(pos: :asc, classnum: :asc, classlet: :asc).where(day: date, teacher_id: current_teacher_id)
    timetable = today_lessons.select(:id, :pos, :subject, :homework, :classnum, :classlet).to_a unless Lesson.find_by(day: date).blank?
  end

  def daily_timetable_min(date)
    current_classnum = params[:chosen_classnum]
    current_classlet = params[:chosen_classlet]
    today_lessons = Lesson.order(pos: :asc, classnum: :asc, classlet: :asc).where(day: date, classnum: current_classnum, classlet: current_classlet)
    timetable = today_lessons.select(:id, :pos, :subject, :homework).to_a unless Lesson.find_by(day: date, classnum: current_classnum, classlet: current_classlet).blank?
    teachers = []
    today_lessons.each_with_index do |lesson, i|
      teachers[i] = Student.find_by(id: lesson.teacher_id).name
    end
    return timetable, teachers
  end

  
end