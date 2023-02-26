class AddTransaction < ActiveRecord::Migration[7.0]
  def change
    enable_extension 'pgcrypto'
    create_table :transactions, id: :uuid do |t|
      t.timestamp :booking_date, null: false
      t.text :status, null: false
      t.text :currency, null: false
      t.text :transaction_type, null: false
      t.bigint :amount, default: 0.0
      t.jsonb :currency_exchange, default: []
      t.json :data, default: {}
      t.timestamps

      t.belongs_to :account, null: false, foreign_key: true, type: :uuid
    end
  end
end
