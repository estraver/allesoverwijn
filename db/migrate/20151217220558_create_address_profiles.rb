class CreateAddressProfiles < ActiveRecord::Migration
  def change
    create_table :address_profiles do |t|
      t.references :address, index: true, foreign_key: true
      t.references :profile, index: true, foreign_key: true
      t.string :address_type, null: false
      t.date :valid_from
      t.date :valid_to

      t.timestamps null: false
    end
  end
end
