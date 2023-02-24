module Api
  module Priora
    module V2
      class AuthorizationsController < ApplicationController
        before_action :authenticate_user!

        def new
          @token_params = {
            application: Application.find_by(uid: auth_params['client_id']),
            token_id: auth_params['token_id']
          }
        end

        def create
          token = Tokens::Create.new(current_user, auth_params).call
          redirect_to token.redirect_uri, allow_other_host: true, via: :get
        end

        private

        def auth_params
          params.permit(:client_id, :token_id)
        end
      end
    end
  end
end
