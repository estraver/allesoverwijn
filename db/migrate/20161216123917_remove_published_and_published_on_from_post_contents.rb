class RemovePublishedAndPublishedOnFromPostContents < ActiveRecord::Migration
  def change
    remove_column :post_contents, :published, :boolean
    remove_column :post_contents, :published_on, :date
  end
end
