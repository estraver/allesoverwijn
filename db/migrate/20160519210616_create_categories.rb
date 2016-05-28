class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.references :post, index: true, foreign_key: true
      t.references :parent_category, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
