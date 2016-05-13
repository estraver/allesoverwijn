class Blog < ActiveRecord::Base
  has_one :post, as: :page
  has_many :contents, through: :post, source: :post_contents

  scope :recent, -> { joins(contents: :properties).where('properties.name = ? AND properties.value >= ?', :published_on, 1.week.ago).distinct }
  scope :published, -> { joins(contents: :properties).where('properties.name = ? AND properties.value = ?', :published, true).distinct }
  # scope :featured, -> { joins(:post).where('posts.featured = true') }

  scope :authored_by, ->(author) { joins(:contents).where('post_contents.author = :author', author: author) }

  class << self
    def properties
      [:published, :published_on]
    end
  end
end
