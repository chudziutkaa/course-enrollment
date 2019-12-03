# frozen_string_literal: true

module Api
  module V1
    class BaseController < ApplicationController
      include Api::V1::Concerns::ErrorHandlers

      PER_PAGE = 10

      before_action :authorize_request_owner

      private

      def authorize_request_owner
        AuthorizeResource.call(request.headers)
      end

      def pagination_meta(collection)
        {
          per_page: collection.limit_value,
          current_page: collection.current_page,
          next_page: collection.next_page,
          prev_page: collection.prev_page,
          total_pages: collection.total_pages,
          total_count: collection.total_count
        }
      end

      def render_collection(collection, options = {})
        options[:json] = collection
        options[:meta] = pagination_meta(collection)
        options[:adapter] = :json
        render options
      end
    end
  end
end
