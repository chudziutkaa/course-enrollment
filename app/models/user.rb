# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  validates :email, presence: true, uniqueness: true

  enum role: { worker: 1, student: 0 }

  has_many :enrollments, dependent: :destroy
  has_many :courses, through: :enrollments
end
