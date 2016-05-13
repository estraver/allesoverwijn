require 'uber/inheritable_attr'

module Recollect::Collection::Paging

  def self.included(base)
    extend Uber::InheritableAttr
    base.inheritable_attr :per_page, clone: false
    base.per_page = 10

    base.extend Paging
  end

  module Paging
    def paging(options = {})
      self.per_page = options.delete(:per_page) if options.key?(:per_page)
    end
  end

  def setup_collection!(collection, *args)
    @current_page ||= 1
    collection.limit(self.class.per_page).offset(@current_page)
  end

  def page(num)

  end

  def next(offset = 1)

  end

  def prev(offset = -1)

  end

  private
  module ModelReaders
    attr_reader :current_page
  end
  include ModelReaders
end