module Api
  module Priora
    module V2
      class AccountsController < ApplicationController
        before_action :set_current_user

        def index
          result = Accounts::Find.new(current_user).call
          render json: result
        end

        def show
          result = Accounts::Transactions::Show.new(current_user, transactions_params).call
          render json: result
        end

        private

        def transactions_params
          request.headers['Authorization'].split(' ').last
        end
      end
    end
  end
end
