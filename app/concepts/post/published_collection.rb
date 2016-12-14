require 'recollect/recollect'
require 'recollect/paging'
require 'recollect/array'

class PublishedCollection < Recollect::Collection
  include Paging, Cell, Array

  scope -> { joins(contents: :properties).where('properties.name = ? AND properties.value = ?', :published, true).distinct }
end