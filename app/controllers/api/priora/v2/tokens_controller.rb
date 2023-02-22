module Api
  module Priora
    module V2
      class TokensController < Doorkeeper::TokensController
        def create
          Token::Prepare.new(auth_signature, new_user_session_url).call
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
