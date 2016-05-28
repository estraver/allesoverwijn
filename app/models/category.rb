class Category < ActiveRecord::Base
  has_and_belongs_to_many :posts, join_table: 'categorization'
  has_many :category_names

  has_many :child_categories, class_name: 'Category', foreign_key: 'parent_category_id'
  belongs_to :parent_category, class_name: 'Category'

  attr_accessor :name
  attr_accessor :locale
end
