class RemovePostFromCategories < ActiveRecord::Migration
  def change
    remove_reference :categories, :post, index: true, foreign_key: true
  end
end
