module Accounts
  class Find
    attr_reader :user

    def initialize(user)
      @user = user
    end

    def call
      accounts = Account.where(user_id: user.id, account_type: 'account')
      { data: accounts.map { |account| Representers::Account.new(account).call } }
    end
  end
end
