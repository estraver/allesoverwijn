class Post < ActiveRecord::Base
  belongs_to :page, :polymorphic => true
  has_many :post_contents
  has_and_belongs_to_many :categories, join_table: 'categorization'

  attr_accessor :title
  attr_accessor :article
  attr_accessor :locale
  attr_accessor :author

  serialize :picture_meta_data

end
