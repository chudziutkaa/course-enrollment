# frozen_string_literal: true

class AuthorizeResource < BaseService
  AuthorizationRequestHeaderMissing = Class.new(StandardError)

  def initialize(headers = {})
    @authorization_header = headers['Authorization']
  end

  def call
    resource
  end

  private

  attr_reader :authorization_header

  def token
    return authorization_header.split(' ').last if authorization_header.present?

    raise AuthorizationRequestHeaderMissing, 'Missing Authorization Request header'
  end

  def decoded_token
    JsonWebToken.decode(token, Rails.application.credentials[:secret_key_base])
  end

  def resource
    @resource = Employee.find(decoded_token[:resource_id])
  end
end
