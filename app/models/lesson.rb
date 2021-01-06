# frozen_string_literal: true

class Lesson < ApplicationRecord
  validates :day, :pos, :subject, :classnum, :classlet, presence: true
  has_many :grades
end
