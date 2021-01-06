# frozen_string_literal: true

class Student < ApplicationRecord
  validates :name, :role, presence: true
  validates :name, :email, uniqueness: true
  has_many :grades
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
