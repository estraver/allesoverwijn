class CreateCategoryNames < ActiveRecord::Migration
  def change
    create_table :category_names do |t|
      t.string :name, null: false
      t.string :locale, limit: 2, null: false

      t.references :category, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
