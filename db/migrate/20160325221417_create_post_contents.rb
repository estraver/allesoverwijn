class CreatePostContents < ActiveRecord::Migration
  def change
    create_table :post_contents do |t|
      t.string :title, null: false
      t.text :article, null: false
      t.boolean :published, default: false
      t.date :published_on
      t.references :post, index: true, foreign_key: true
      t.references :author, index: true
      t.string :locale, limit: 2, null: false

      t.timestamps null: false
    end
  end

  add_foreign_key :post_contents, :users, column: :author_id
end
