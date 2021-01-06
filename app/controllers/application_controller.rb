class ApplicationController < ActionController::Base
    before_action :authenticate_student!
    protect_from_forgery with: :exception

     before_action :configure_permitted_parameters, if: :devise_controller?

     around_action :switch_locale

     protected

          def configure_permitted_parameters
               devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:name, :email, :password, :role, :classnum, :classlet)}
               devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:name, :email, :password, :current_password, :role, :classnum, :classlet)}
          end

          def current_student_is_teacher?
               if !current_student.role.include? "Teacher"
                    flash[:notice] = "This page is available only for teachers"
                    redirect_back(fallback_location: root_path)
               end
          end

          def current_student_is_admin?
               if !(current_student.role == "Administrator")
                    flash[:notice] = "This page is available only for administrators"
                    redirect_back(fallback_location: root_path)
               end
          end

          def current_student_is_teacher_or_admin?
               if !(current_student.role.include?("Teacher") or (current_student.role == "Administrator"))
                    flash[:notice] = "This page is available only for teachers and administrators"
                    redirect_to root_path
               end
          end
           
          def current_student_is_student?
               if !(current_student.role == "Student")
                    flash[:notice] = "This page is available only for students"
                    redirect_back(fallback_location: root_path)
               end
          end

          def correct_subject?
               if current_student.role.include?("Teacher")
                    current_id = current_student.id
                    chosen_lesson_teacher_id = Lesson.find_by(id: params[:id]).teacher_id
                    if current_id != chosen_lesson_teacher_id
                         flash[:notice] = "This page is available only for following teacher: " + Student.find_by(id: chosen_lesson_teacher_id).name
                         redirect_back(fallback_location: root_path)
                    end
               end
          end

          def switch_locale(&action)
               locale = params[:locale] || I18n.default_locale
               I18n.with_locale(locale, &action)
          end
end

