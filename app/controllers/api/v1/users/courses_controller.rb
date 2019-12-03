# frozen_string_literal: true

module Api
  module V1
    module Users
      class CoursesController < Api::V1::BaseController
        def index
          courses = user.courses.includes(:enrollments).page(params[:page]).per(PER_PAGE)
          render_collection courses, each_serializer: Api::V1::Users::CoursesSerializer
        end

        private

        def user
          @user ||= User.find(params[:user_id])
        end
      end
    end
  end
end
