class CreateJoinTablePostsTags < ActiveRecord::Migration
  def change
    create_join_table :post_contents, :tags, table_name: :taggings do |t|
      t.index [:post_content_id, :tag_id]
      t.index [:tag_id, :post_content_id]
    end
  end
end
