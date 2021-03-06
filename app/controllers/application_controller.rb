# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_student!
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  before_action :set_locale

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:name, :email, :password, :role, :classnum, :classlet) }
    devise_parameter_sanitizer.permit(:account_update) do |u|
      u.permit(:name, :email, :password, :current_password, :role, :classnum, :classlet)
    end
  end

  def current_student_is_teacher
    unless current_student.role.include? 'Teacher'
      flash[:notice] = 'This page is available only for teachers'
      redirect_back(fallback_location: root_path)
    end
  end

  def current_student_is_admin
    unless current_student.role == 'Administrator'
      flash[:notice] = 'This page is available only for administrators'
      redirect_back(fallback_location: root_path)
    end
  end

  def current_student_is_teacher_or_admin
    unless current_student.role.include?('Teacher') || (current_student.role == 'Administrator')
      flash[:notice] = 'This page is available only for teachers and administrators'
      redirect_to root_path
    end
  end

  def current_student_is_student
    unless current_student.role == 'Student'
      flash[:notice] = 'This page is available only for students'
      redirect_back(fallback_location: root_path)
    end
  end

  def correct_subject
    if current_student.role.include?('Teacher')
      current_id = current_student.id
      if !params[:id].nil?
        chosen_id = params[:id]
      elsif !params[:updated_lesson].nil?
        chosen_id = params[:updated_lesson]
      end
      chosen_lesson_teacher_id = Lesson.find_by(id: chosen_id).teacher_id
      if current_id != chosen_lesson_teacher_id
        allowed_teacher = Student.find_by(id: chosen_lesson_teacher_id).name
        flash[:notice] = "This page is available only for following teacher: #{allowed_teacher}"
        redirect_back(fallback_location: root_path)
      end
    end
  end

  private

  def set_locale
    I18n.locale = extract_locale || I18n.default_locale
  end

  def extract_locale
    parsed_locale = params[:locale]
    I18n.available_locales.map(&:to_s).include?(parsed_locale) ? parsed_locale : nil
  end

  def default_url_options
    { locale: I18n.locale }
  end
end
