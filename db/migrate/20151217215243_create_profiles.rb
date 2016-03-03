class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|

      t.string :first_name
      t.string :middle_name
      t.string :last_name
      t.date :date_of_birth
      t.string :birth_place
      t.string :home, limit: 3
      t.integer :gender, default: 0
      t.text :bio
      t.string :country, limit: 3 # Iso
      t.string :language, limit: 2
      t.binary :photo
      t.references :user

      t.timestamps null: false
    end
  end
end
