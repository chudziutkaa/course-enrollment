# frozen_string_literal: true

module Api
  module V1
    class CoursesController < BaseController
      def index
        courses = Course.all.page(params[:page]).per(PER_PAGE)
        render_collection courses, each_serializer: Api::V1::CoursesSerializer
      end

      def create
        course = Course.new(course_params)
        if course.save
          render json: { message: 'Course successfully created' }, status: :created
        else
          render json: { error: course.errors.full_messages.to_sentence },
                 status: :unprocessable_entity
        end
      end

      def destroy
        course = Course.find(params[:id])
        course.destroy
        head :no_content
      end

      private

      def course_params
        params.require(:course).permit(:name)
      end
    end
  end
end
