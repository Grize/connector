module CardAccounts
  module Transactions
    class Show
      include JwtClient
      attr_reader :user
      attr_reader :params

      def initialize(user, params)
        @user = user
        @params = decode(params).first['data']
      end

      def call
        scope = Transaction.where(account_id: params['account_id'], transaction_type: 'card')
                            .where('created_at > ?', params['from_date'])
                            .where('created_at < ?', params['to_date'])

        { data: scope.map { |transaction| Representers::CardTransaction.new(transaction).call } }
      end
    end
  end
end
