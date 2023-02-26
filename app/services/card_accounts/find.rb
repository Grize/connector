module CardAccounts
  class Find
    attr_reader :user

    def initialize(user)
      @user = user
    end

    def call
      accounts = Account.where(user_id: user.id, account_type: 'card_account')
      { data: accounts.map { |account| Representers::CardAccount.new(account).call } }
    end
  end
end
