class AddNameToProperties < ActiveRecord::Migration
  def change
    add_column :properties, :name, :string
  end
end
