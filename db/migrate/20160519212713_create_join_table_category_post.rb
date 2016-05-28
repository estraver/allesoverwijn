class CreateJoinTableCategoryPost < ActiveRecord::Migration
  def change
    create_join_table :posts, :categories, table_name: :categorization do |t|
      t.index [:post_id, :category_id]
      t.index [:category_id, :post_id]
    end
  end
end
