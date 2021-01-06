# frozen_string_literal: true

class Subject < ApplicationRecord
  validates :name, presence: true
end
