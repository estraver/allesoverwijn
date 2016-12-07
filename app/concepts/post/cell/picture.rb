require 'uber/delegates'
require 'attachment/post_attachment'

module Post::Cell
  class Picture < Trailblazer::Cell
    extend Uber::Delegates
    include Cell::ImageCell

    delegates :model, :post
    delegates :post, :picture_meta_data

    attachment :picture, PostAttachment
  end
end