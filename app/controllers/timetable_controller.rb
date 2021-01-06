class TimetableController < ApplicationController

    def show
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
