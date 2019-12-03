# frozen_string_literal: true

module Api
  module V1
    module Users
      class CoursesSerializer < ::ApplicationSerializer
        attributes :id, :name
      end
    end
  end
end
