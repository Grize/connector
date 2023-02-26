module Representers
  class AccountTransaction
    attr_reader :transaction

    def initialize(transaction)
      @transaction = transaction
    end

    def call
      {
        id: transaction.id,
        amount: transaction.amount,
        currency: transaction.currency,
        status: transaction.status,
        creditor_details: data['creditor_details'],
        debtor_details: data['debtor_details'],
        remittance_information: data['remittance_information'],
        currency_exchange: transaction.currency_exchange,
        extra: data['extra_data'],
        value_date: data['value_date'].to_time.iso8601,
        booking_date: transaction['booking_date'].to_time.iso8601
      }
    end

    private

    def data
      transaction.data
    end
  end
end
