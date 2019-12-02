# frozen_string_literal: true

class AuthenticateResource < BaseService
  MissingParams = Class.new(StandardError)
  InvalidCredentials = Class.new(StandardError)

  def initialize(params)
    @params = params
  end

  def call
    validate_presence_of_params
    authenticate_resource
    JsonWebToken.encode(encoding_params, Rails.application.credentials[:secret_key_base])
  end

  private

  attr_reader :params

  def email
    params[:email]
  end

  def password
    params[:password]
  end

  def validate_presence_of_params
    return if email.present? && password.present?

    raise MissingParams, 'Email or password are missing'
  end

  def resource
    @resource ||= Employee.find_by!(email: email)
  end

  def authenticate_resource
    return if resource.authenticate(password)

    raise InvalidCredentials, 'Invalid password'
  end

  def encoding_params
    {
      resource_id: resource.id,
      exp: 24.hours.from_now.to_i
    }
  end
end
