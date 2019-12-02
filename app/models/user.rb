# frozen_string_literal: true

class User < ApplicationRecord
  validates :email, presence: true, uniqueness: true

  has_many :enrollments, dependent: :destroy
  has_many :courses, through: :enrollments
end
