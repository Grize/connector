module Tokens
  class Create < Tokens::Base
    attr_reader :user
    attr_reader :params
    attr_reader :updated_token

    def initialize(user, params)
      @user = user
      @params = params
    end

    def call
      @updated_token = update_token
      super
      updated_token
    end

    private

    def data_payload
      {
        session_secret: updated_token.external_token,
        token: updated_token.token,
        user_id: user.id,
        consent: {
          allPsd2: 'allAccounts'
        }
      }
    end

    def endpoint
      "sessions/#{updated_token.external_token}/success"
    end

    def update_token
      token = Token.find_by(id: params['token_id'], status: 'draft')
      token.update(users_id: user.id, status: 'active')
      token
    end
  end
end
