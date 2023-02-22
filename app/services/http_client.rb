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
    Rails.logger.info "Making request with method: #{method}, with headers: #{headers}, payload: #{payload}, path: {path}"
    response = HTTP.headers(**headers).send(method, path)
    Rails.logger.info "response: #{response}"
  end

  private

  def path
    "#{salt_edge_path}/#{endpoint}"
  end

  def headers
    {
      "Authorization": "Bearer #{encode(payload)}",
      "App-Id": app_id,
      "App-Secret": app_secret
    }
  end
end
