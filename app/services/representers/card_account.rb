module Representers
  class CardAccount
    attr_reader :account

    def initialize(account)
      @account = account
    end

    def call
      {
        id: account.id,
        name: account.name,
        masked_pan: data['pan'].gsub(/\d(?=[0-9]{4})/, '*'),
        currency: account.currency,
        product: account.product_name,
        status: account.status,
        credit_limit: data['credit_limit'],
        extra: data['extra'],
        balances: account.balances.map { |balance| CardBalance.new(balance).call }
      }
    end

    private

    def data
      account.data
    end
  end
end
