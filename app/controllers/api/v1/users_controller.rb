# frozen_string_literal: true

module Api
  module V1
    class UsersController < BaseController
      def create
        user = User.new(user_params)
        if user.save
          render json: { message: 'User successfully created' }, status: :created
        else
          render json: { error: user.errors.full_messages.to_sentence },
                 status: :unprocessable_entity
        end
      end

      def destroy
        user = User.find(params[:id])
        user.destroy
        head :no_content
      end

      private

      def user_params
        params.require(:user).permit(:email)
      end
    end
  end
end
