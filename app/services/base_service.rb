# frozen_string_literal: true

class BaseService
  private_class_method :new

  class << self
    def call(*args)
      new(*args).call
    end
  end
end
