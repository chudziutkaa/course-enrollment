# frozen_string_literal: true

module Api
  module V1
    module Employees
      class AuthenticationController < Api::V1::BaseController
        skip_before_action :authorize_request

        def authenticate
          token = AuthenticateResource.call(authentication_params)
          render json: { auth_token: token }, status: :ok
        rescue AuthenticateResource::InvalidCredentials => e
          render_unauthorized_response(e)
        rescue ActionController::ParameterMissing, AuthenticateResource::MissingParams
          render_parameter_missing_response
        rescue ActiveRecord::RecordNotFound
          render_record_not_found_response
        end

        private

        def required_params
          %i[email password]
        end

        def authentication_params
          params.require(required_params)
          params.permit(required_params)
        end
      end
    end
  end
end