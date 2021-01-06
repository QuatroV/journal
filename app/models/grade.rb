# frozen_string_literal: true

class Grade < ApplicationRecord
  validates :value, :student_id, :lesson_id, presence: true
  belongs_to :student
  belongs_to :lesson
end
