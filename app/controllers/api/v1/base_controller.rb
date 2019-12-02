# frozen_string_literal: true

module Api
  module V1
    class BaseController < ApplicationController
      include Api::V1::Concerns::ErrorHandlers

      before_action :authorize_request_owner

      private

      def authorize_request_owner
        AuthorizeResource.call(request.headers)
      end
    end
  end
end
