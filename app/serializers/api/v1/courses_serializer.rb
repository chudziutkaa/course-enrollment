# frozen_string_literal: true

module Api
  module V1
    class CoursesSerializer < ApplicationSerializer
      attributes :id, :name, :users_count
    end
  end
end
