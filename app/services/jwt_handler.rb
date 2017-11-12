class JwtHandler
  HMAC_SECRET = Rails.application.secrets.secret_key_base

  def self.encode(payload)
    JWT.encode(payload, HMAC_SECRET)
  end

  def self.decode(token)
    decoded_token = JWT.decode(token, HMAC_SECRET)[0]
    HashWithIndifferentAccess.new(decoded_token)
    # TODO: Add error handling
  end
end
