class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      # t.integer :page_id, null: false
      # t.string :page_type, null: false
      t.references :page, polymorphic: true, null: false, index: true
      # t.boolean :features, default: false
      # t.boolean :comment_allowed, default: true

      t.timestamps null: false
    end
  end
end
