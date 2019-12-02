# frozen_string_literal: true

module Api
  module V1
    module Concerns
      module ErrorHandlers
        extend ActiveSupport::Concern

        included do
          rescue_from ActiveRecord::RecordNotFound, with: :render_record_not_found_response
          rescue_from AuthorizeResource::AuthorizationRequestHeaderMissing,
            with: :render_bad_request_response
          rescue_from JsonWebToken::ExpiredSignature, JsonWebToken::DecodeError do |e|
            render_unauthorized_response(e)
          end

          private

          def render_bad_request_response
            render json: { error: 'Bad request' }, status: :bad_request
          end

          def render_unauthorized_response(error_message)
            render json: { error: error_message }, status: :unauthorized
          end

          def render_parameter_missing_response
            render json: { error: 'Missing required parameters' }, status: :unprocessable_entity
          end

          def render_record_not_found_response
            render json: { error: 'Resource not found' }, status: :not_found
          end

          def render_exception(error_message, status)
            render json: { error_message: error_message }, status: status
          end
        end
      end
    end
  end
end