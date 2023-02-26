module Representers
  class CardTransaction
    attr_reader :transaction

    def initialize(transaction)
      @transaction = transaction
    end

    def call
      {
        id: transaction.id,
        amount: transaction.amount,
        terminal_id: data['terminal_id'],
        currency: transaction.currency,
        status: transaction.status,
        original_amount: data['original_amount'],
        markup_fee: data['markup_fee'],
        markup_fee_percentage: data['markup_fee_percentage'],
        card_acceptor_id: data['card_acceptor_id'],
        card_acceptor_address: data['card_acceptor_address'],
        merchant_category_code: data['merchant_category_code'],
        masked_pan: data['masked_pan'].gsub(/\d(?=[0-9]{4})/, '*'),
        transaction_details: data['transaction_details'],
        invoiced: data['invoiced'],
        currency_exchange: transaction.currency_exchange,
        proprietary_bank_transaction_code: data['proprietary_bank_transaction_code'],
        booking_date: transaction['booking_date'].to_time.iso8601
      }
    end

    private

    def data
      transaction.data
    end
  end
end
