# frozen_string_literal: true

class Course < ApplicationRecord
  validates :email, presence: true

  has_many :enrollments, dependent: :destroy
  has_many :users, through: :enrollments
end
