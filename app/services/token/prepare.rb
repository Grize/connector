module Token
  class Prepare < Token::Base
    include JwtClient
    attr_reader :params
    attr_reader :redirect_url

    def initialize(signature, redirect_url)
      @params = decode(signature).first['data']
      @redirect_url = redirect_url
    end

    def call
      super
      # REDIS_CLIENT.set(params['session_secret'], token_data)
    end

    private

    def token_data
      {
        app_name: params['app_name'],
        recurring_indicator: params['recurring_indicator'],
        valid_until: params['valid_until'],
        redirect_url: params['redirect_url']
      }.to_json
    end

    def endpoint
      "sessions/#{params['session_secret']}/update"
    end

    def data_payload
      {
        session_secret: params['session_secret'],
        redirect_url: "#{redirect_url}?client_id=#{application.uid}&redirect_uri=#{URI.encode_www_form_component(params['redirect_url'])}&grant_type=authorization_code&response_type=code&scope=all"
      }
    end
  end
end
