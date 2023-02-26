module Api
  module Priora
    module V2
      class CardAccountsController < ApplicationController
        before_action :set_current_user

        def index
          result = CardAccounts::Find.new(current_user).call
          render json: result
        end

        def show
          result = CardAccounts::Transactions::Show.new(current_user, transactions_params).call
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
