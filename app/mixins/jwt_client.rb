module JwtClient
  include SaltEdge
  include AppConfig

  def decode(signature)
    JWT.decode(signature, salt_edge_public_key, true, algorithm)
  end

  def encode(payload)
    JWT.encode(payload, private_key, 'RS256')
  end

  private

  def algorithm
    { algorithm: 'RS256' }
  end
end
