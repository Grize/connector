class HttpClient
  include JwtClient

  attr_reader :endpoint
  attr_reader :payload
  attr_reader :method

  def initialize(endpoint, payload, method)
    @endpoint = endpoint
    @payload = payload
    @method = method
  end

  def call
    HTTP.headers(**headers).send(method, path)
  end

  private

  def path
    File.join(salt_edge_path, endpoint)
  end

  def headers
    {
      "Authorization": "Bearer #{encode(payload)}",
      "App-Id": app_id,
      "App-Secret": app_secret
    }
  end
end
