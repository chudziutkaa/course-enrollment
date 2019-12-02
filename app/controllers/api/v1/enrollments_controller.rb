# frozen_string_literal: true

module Api
  module V1
    class EnrollmentsController < BaseController
      def create
        if Enrollments::Create.call(enrollment_params[:course_id], enrollment_params[:user_id])
          render json: { message: 'User successfully enrolled to the course' }, status: :created
        else
          render json: { error: 'Enrollment user to this course failed' },
                 status: :unprocessable_entity
        end
      end

      def destroy
        if Enrollments::Delete.call(params[:id])
          head :no_content
        else
          render json: { error: 'Cannot withdraw user from this course' },
                 status: :unprocessable_entity
        end
      end

      private

      def enrollment_params
        params.require(:enrollment).permit(:course_id, :user_id)
      end
    end
  end
end
