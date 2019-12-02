# frozen_string_literal: true

class Course < ApplicationRecord
  validates :name, presence: true

  has_many :enrollments, dependent: :destroy
  has_many :users, through: :enrollments
end
