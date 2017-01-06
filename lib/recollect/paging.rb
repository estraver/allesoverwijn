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
    @current_page = @params[:page] || 1
    collection.limit(per_page).offset(@current_page - 1 * per_page)
  end

  def per_page
    self.class.per_page
  end

  def page
    @page ||= Page.new(self, @current_page)
  end

  # def next(offset = 1)
  #
  # end
  #
  # def prev(offset = -1)
  #
  # end

  private

  module ModelReaders
    attr_reader :current_page
  end
  include ModelReaders

  class Page < Struct.new(:collection, :current_page)
    include Rails.application.routes.url_helpers

    def first?
      current_page.eql? 1
    end

    def last?
      collection.count < collection.per_page || current_page.eql?(collection.count / collection.per_page)
    end

    def previous
      first? ? self : Page.new(collection, current_page - 1)
    end

    def next
      last? ? self : Page.new(collection, current_page + 1)
    end

    def url
      send("#{collection.model.name.downcase.pluralize}_path", page: current_page)
    end
  end

end