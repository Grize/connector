class AddAccount < ActiveRecord::Migration[7.0]
  def change
    enable_extension 'pgcrypto'
    create_table :accounts, id: :uuid do |t|
      t.text :name, null: false
      t.text :currency, null: false
      t.text :status, null: false
      t.text :product_name, null: false
      # Only for demo propose!
      # TODO: Think how split to different records!
      t.json :data, default: {}
      t.text :account_type, null: false
      t.timestamps

      t.belongs_to :user, foreign_key: true
    end
  end
end
