class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :line_1
      t.string :line_2
      t.string :line_3
      t.string :city
      t.string :country_province
      t.string :zip_or_postcode
      t.string :country, limit: 3
      t.string :other_address_details

      t.timestamps null: false
    end
  end
end
