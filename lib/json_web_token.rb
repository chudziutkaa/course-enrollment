# frozen_string_literal: true

class JsonWebToken
  ExpiredSignature = Class.new(StandardError)
  DecodeError = Class.new(StandardError)

  ALGORITHM = 'HS256'

  class << self
    def encode(payload, hmac_secret)
      JWT.encode(payload, hmac_secret, ALGORITHM)
    end

    def decode(token, hmac_secret)
      JWT.decode(token, hmac_secret, true, algorithm: ALGORITHM)[0].with_indifferent_access
    rescue JWT::ExpiredSignature
      raise ExpiredSignature, 'Token expired'
    rescue JWT::DecodeError
      raise DecodeError, 'Invalid token supplied.'
    end
  end
end
