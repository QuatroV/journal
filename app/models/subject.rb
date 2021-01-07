# frozen_string_literal: true

class Subject < ApplicationRecord
  validates :name, presence: true
  validates :name, uniqueness: true
end
