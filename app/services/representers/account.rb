module Representers
  class Account
    attr_reader :account

    def initialize(account)
      @account = account
    end

    def call
      {
        id: account.id,
        name: account.name,
        iban: data['iban'],
        currency: account.currency,
        cash_account_type: data['cash_type'],
        product: account.product_name,
        bban: data['bban'],
        bic: data['bic'],
        sort_code: data['sort_code'],
        msisdn: data['msisdn'],
        status: account.status,
        balances: account.balances.map { |balance| AccountBalance.new(balance).call }
      }
    end

    private

    def data
      account.data
    end
  end
end
