class CreateAuthMetaData < ActiveRecord::Migration
  def change
    create_table :auth_meta_data do |t|
      t.string :password_digest, null: false, default: ''

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      # Confirmable
      t.string   :confirmation_token
      t.datetime :confirmation_created_at
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at

      t.references :user, null: false
      t.timestamps null: false
    end
  end
end
