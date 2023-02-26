class AddBalance < ActiveRecord::Migration[7.0]
  def change
    create_table :balances do |t|
      t.text :balance_type, null: false
      t.text :currency, null: false
      t.bigint :amount, null: false, default: 0.0
      t.boolean :credit_limit_included, null: false, default: false
      t.timestamps

      t.belongs_to :account, null: false, foreign_key: true, type: :uuid
    end
  end
end
