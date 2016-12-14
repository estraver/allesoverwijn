require 'recollect/recollect'
require 'recollect/array'

class ArchiveCollection < Recollect::Collection
  include Array

  scope -> { where('name = ? AND value <= ?', :published_on, Date.today).group('DATE(value)').count  }
end