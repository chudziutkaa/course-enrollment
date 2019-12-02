# frozen_string_literal: true

module Enrollments
  class Delete < BaseService
    def initialize(enrollment_id)
      @enrollment_id = enrollment_id
    end

    def call
      ActiveRecord::Base.transaction do
        course.decrement(:users_count).save!
        enrollment.destroy!
      end
      true
    rescue ActiveRecord::RecordNotFound
      false
    end

    private

    attr_reader :enrollment_id

    def enrollment
      @enrollment ||= Enrollment.find(enrollment_id)
    end

    def course
      @course = enrollment.course
    end
  end
end
