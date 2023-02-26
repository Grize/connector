module Representers
  class AccountBalance
    attr_reader :balance

    def initialize(balance)
      @balance = balance
    end

    def call
      {
        type: balance.balance_type,
        currency: balance.currency,
        amount: balance.amount,
        last_change_date_time: balance.updated_at.to_time.iso8601
      }
    end
  end
end
