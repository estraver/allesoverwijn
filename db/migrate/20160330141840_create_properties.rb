class CreateProperties < ActiveRecord::Migration
  def change
    create_table :properties do |t|
      t.string :value
      t.references :post_content, index: true, foreign_key: true
      t.references :property_type, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
