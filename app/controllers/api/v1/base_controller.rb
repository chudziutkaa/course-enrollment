# frozen_string_literal: true

module Api
  module V1
    class BaseController < ApplicationController
      before_action :authorize_request
      attr_reader :current_user

      include Api::V1::ErrorHandlers

      private

      def authorize_request
        @current_user = AuthorizeUser.call(request.headers)
        return if current_user.present?

        render json: { error: 'Not Authorized' }, status: :unauthorized
      end
    end
  end
end
