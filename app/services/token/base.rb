module Token
  class Base
    def call
      HttpClient.new(endpoint, payload, :patch).call
    end

    private

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
