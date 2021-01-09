# frozen_string_literal: true

class SubjectController < ApplicationController
  before_action :current_student_is_admin, only: %i[show_all_subjects add_subject delete_subject]

  def show_all_subjects; end

  def add_subject
    Subject.create(name: params[:subject_name])
    redirect_back(fallback_location: root_path)
  end

  def delete_subject
    Subject.find_by(name: params[:name]).destroy
    redirect_back(fallback_location: root_path)
  end
end
