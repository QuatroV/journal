class StudentController < ApplicationController

    before_action :current_student_is_admin?, :only => [:show_all_students, :get_all_students]

    def show_all_students
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
end
