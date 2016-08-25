require 'recollect/recollect'
require 'recollect/twin'
require 'recollect/paging'
# require 'abstract_post/abstract_post'

module AbstractPost
  class PublishedCollection < Recollect::Collection
    include Twin, Paging

    scope -> { joins(contents: :properties).where('properties.name = ? AND properties.value = ?', :published, true).distinct }
    # twin AbstractPost::Entry
  end
end