class Account < ApplicationRecord
  belongs_to :user, class_name: 'User'
  has_many :balances, foreign_key: 'account_id'
  has_many :transactions, foreign_key: 'account_id'
end
