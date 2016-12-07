require 'recollect/recollect'
require 'recollect/paging'

class PublishedCollection < Recollect::Collection
  include Paging, Cell

  scope -> { joins(contents: :properties).where('properties.name = ? AND properties.value = ?', :published, true).distinct }
end