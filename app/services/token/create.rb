module Token
  class Create < Token::Base
    attr_reader :user
    attr_reader :params

    def initialize(user, params)
      super
      @user = user
      @params = params
    end

    private

    def data_payload
      {
        session_secret: params['session_secret'],
        token: create_token,
        user_id: user.id
      }
    end

    def endpoint
      "sessions/#{params['session_secret']}/success"
    end

    def token_params
      {
        application_id: application_id,
        expires_in: token_data['valid_until'],
        exclude_token: params['session_secret'],
        resource_owner_id: user.id
      }
    end

    def create_token
      Doorkeeper::AccessToken.create(**token_params).token
    end

    def token_data
      # REDIS_CLIENT.get(params['session_secret'])
    end
  end
end
