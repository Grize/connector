module Representers
  class CardBalance
    attr_reader :balance

    def initialize(balance)
      @balance = balance
    end

    def call
      {
        type: balance.balance_type,
        balance_amount: {
          currency: balance.currency,
          amount: balance.amount
        }
      }
    end
  end
end
