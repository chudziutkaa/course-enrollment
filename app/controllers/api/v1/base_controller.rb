# frozen_string_literal: true
# require 'api/v1/concerns/error_handlers'

module Api
  module V1
    class BaseController < ApplicationController
      include Api::V1::Concerns::ErrorHandlers

      before_action :authorize_request
      attr_reader :current_user

      private

      def authorize_request
        @current_user = AuthorizeResource.call(request.headers)
        return if current_user.present?

        render json: { error: 'Not Authorized' }, status: :unauthorized
      end
    end
  end
end
