class PostContent < ActiveRecord::Base
  belongs_to :author, counter_cache: :posts_count,
             class_name: 'User', foreign_key: 'author_id'

  has_and_belongs_to_many :tags, join_table: 'taggings'

  belongs_to :post

  has_many :properties
end
