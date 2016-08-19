class Post < ActiveRecord::Base
  belongs_to :page, :polymorphic => true
  has_many :post_contents
  has_and_belongs_to_many :categories, join_table: 'categorization'

  serialize :picture_meta_data
end
