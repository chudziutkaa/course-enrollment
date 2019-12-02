# frozen_string_literal: true

module Api
  module V1
    class CoursesController < BaseController
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
