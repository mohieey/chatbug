class AuthTokenService
  HMAC_SECRET = ENV["HMAC_SECRET"]
  ALGO_TYPE = "HS256"

  def self.encode(user_id)
    payload = { user_id: user_id }

    JWT.encode payload, HMAC_SECRET, ALGO_TYPE
  end

  def self.decode(token)
    decoded_token = JWT.decode token, HMAC_SECRET, true, { algorithm: ALGO_TYPE }
    decoded_token[0]["user_id"]
  end
end
