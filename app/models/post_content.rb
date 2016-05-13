class PostContent < ActiveRecord::Base
  belongs_to :author, counter_cache: :posts_count,
             class_name: 'User', foreign_key: 'author_id'

  belongs_to :post

  has_many :properties
end
