class JwtService
  ALGORITHM = "HS256".freeze
  ACCESS_EXPIRATION = 15.minutes.to_i
  # refresh expiration is handled by RefreshToken.expires_at

  def self.secret
    # prefer ENV; fallback to Rails secret
    ENV["JWT_SECRET"] || Rails.application.secret_key_base
  end

  # returns [token, payload]
  def self.encode_access(payload = {})
    exp = Time.now.to_i + ACCESS_EXPIRATION
    jti = SecureRandom.uuid
    body = payload.merge({ exp: exp, jti: jti, typ: "access" })
    token = JWT.encode(body, secret, ALGORITHM)
    [ token, body ]
  end

  def self.decode(token)
    decoded = JWT.decode(token, secret, true, { algorithm: ALGORITHM })
    decoded[0].with_indifferent_access
  rescue JWT::ExpiredSignature
    raise JWT::ExpiredSignature
  rescue JWT::DecodeError => e
    raise e
  end
end
