module Tokens
  class Base
    private

    def request_salt_edge
      HttpClient.new(endpoint, payload, :patch).call
    end

    def endpoint
      raise NowImplementedError
    end

    def payload
      {
        data: data_payload,
        exp: 2.days.from_now.to_i
      }
    end
  end
end
