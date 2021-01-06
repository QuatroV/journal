class TeacherController < ApplicationController

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

    def show_all_teachers
    end
end
