# frozen_string_literal: true

module Enrollments
  class Create < BaseService
    def initialize(course_id, user_id)
      @course_id = course_id
      @user_id = user_id
    end

    def call
      create_enrollment
      true
    rescue ActiveRecord::RecordInvalid
      false
    end

    private

    attr_reader :course_id, :user_id

    def create_enrollment
      ActiveRecord::Base.transaction do
        Enrollment.create!(course_id: course_id, user_id: user_id)
        course.increment(:users_count).save!
      end
    end

    def course
      @course = Course.find(course_id)
    end
  end
end
