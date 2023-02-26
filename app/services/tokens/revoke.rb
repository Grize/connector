module Tokens
  class Revoke
    attr_reader :token

    def initialize(token)
      @token = token
    end

    def call
      Token.find_by(token: token).update(expired_at: 2.days.from_now)
    end
  end
end
