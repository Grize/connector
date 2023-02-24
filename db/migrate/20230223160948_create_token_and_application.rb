class CreateTokenAndApplication < ActiveRecord::Migration[7.0]
  def change
    enable_extension 'pgcrypto'
    create_table :applications do |t|
      t.text :uid, null: false
      t.text :name, null: false
      t.text :secret, null: false

      t.timestamps
    end

    create_table :tokens, id: :uuid do |t|
      t.text :token, null: false
      t.text :redirect_uri, null: false
      t.text :status, null: false
      t.text :external_token, null: false
      t.timestamps

      t.belongs_to :users, foreign_key: true
      t.belongs_to :applications, foreign_key: true
    end

    add_index :tokens, :token, unique: true
  end
end
