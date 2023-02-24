module Api
  module Priora
    module V2
      class TokensController < ApplicationController
        def create
          Tokens::Prepare.new(auth_signature, new_api_priora_v2_authorization_url).call
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
