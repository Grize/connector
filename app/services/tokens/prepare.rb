module Tokens
  class Prepare < Tokens::Base
    include JwtClient
    attr_reader :params
    attr_reader :redirect_url
    attr_reader :token

    def initialize(signature, redirect_url)
      @params = decode(signature).first['data']
      @redirect_url = redirect_url
    end

    def call
      @token = create_token
      super
    end

    private

    def endpoint
      "sessions/#{params['session_secret']}/update"
    end

    def data_payload
      {
        session_secret: params['session_secret'],
        redirect_url: "#{redirect_url}?client_id=#{application.uid}&token=#{token.token}"
      }
    end

    def application
      Application.find_by(name: params['app_name'])
    end

    def create_token
      Token.create(
        external_token: params['session_secret'],
        applications_id: application.id,
        redirect_uri: params['redirect_url'],
        token: SecureRandom.urlsafe_base64,
        status: 'draft'
      )
    end
  end
end
