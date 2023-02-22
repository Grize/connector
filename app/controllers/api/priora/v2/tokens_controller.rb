module Api
  module Priora
    module V2
      class TokensController < ApplicationController
        def create
          Token::Prepare.new(auth_signature, oauth_authorization_url).call
          render status: 200, body: {}
        end

        private

        def auth_signature
          request.headers['Authorization'].split(' ').last
        end
      end
    end
  end
end
