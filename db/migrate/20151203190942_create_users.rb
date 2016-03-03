class CreateUsers < ActiveRecord::Migration

  def change
    adapter_type = connection.adapter_name.downcase.to_sym
    create_table :users do |t|
      ## Database authenticatable
      t.string :name,            null: false
      t.string :email,           null: false, default: ''

      ## Rememberable
      # t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      case adapter_type
        when :sqlite
          t.string   :current_sign_in_ip
          t.string   :last_sign_in_ip
        when :postgresql
          t.inet     :current_sign_in_ip
          t.inet     :last_sign_in_ip
        else
          raise NotImplementedError, "Unknown adapter type '#{adapter_type}'"
      end

      ## Lockable
      # t.integer  :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
      # t.string   :unlock_token # Only if unlock strategy is :email or :both
      # t.datetime :locked_at

      t.text :auth_meta_data

      t.timestamps null: false
    end
  end
end
