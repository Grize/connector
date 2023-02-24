module JwtClient
  def decode(signature, public_key = SaltEdge.public_key)
    JWT.decode(signature, public_key, true, algorithm)
  end

  def encode(payload, private_key = AppConfig.private_key)
    JWT.encode(payload, private_key, 'RS256')
  end

  private

  def algorithm
    { algorithm: 'RS256' }
  end
end
