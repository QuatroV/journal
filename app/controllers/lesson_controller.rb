class LessonController < ApplicationController

    skip_before_action :verify_authenticity_token, :only => [:update_grades, :update_homework, :create_lesson]
    before_action :current_student_is_admin?, :only => [:delete_lesson, :new_lesson, :create_lesson]
    before_action :correct_subject?, :only => [:show_lesson, :update_grades, :update_homework]

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

    def delete_lesson
        Grade.where(lesson_id: params[:chosen_lesson]).destroy_all
        Lesson.find_by(id: params[:chosen_lesson]).destroy
        redirect_to root_url
    end
      
    def new_lesson
    end
    
    def create_lesson
        if teacher_is_free?(params[:day], params[:pos], params[:teacher_id]) then
            Lesson.create(day: params[:day], pos: params[:pos], subject: params[:subject], teacher_id: params[:teacher_id], homework: params[:homework], classnum: params[:classnum], classlet: params[:classlet])
        end
    end

    private

    def teacher_is_free?(t_day, t_pos, t_teacher_id)
        search = Lesson.find_by(day: t_day, pos: t_pos, teacher_id: t_teacher_id)
        search == nil
    end

end
