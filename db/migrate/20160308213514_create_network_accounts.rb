class CreateNetworkAccounts < ActiveRecord::Migration
  def change
    create_table :network_accounts do |t|
      t.string :account, null: false
      t.integer :account_type, null: false
      t.references :profile, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
