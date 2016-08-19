class RemoveAuthMetaDataFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :auth_meta_data, :string
  end
end
