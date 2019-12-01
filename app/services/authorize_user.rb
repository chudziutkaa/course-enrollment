# frozen_string_literal: true

class AuthorizeUser < BaseService
  AuthorizationRequestHeaderMissing = Class.new(StandardError)

  def initialize(headers = {})
    @authorization_header = headers['Authorization']
  end

  def call
    user
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

  def user
    @user = User.worker.find(decoded_token[:user_id])
  end
end
