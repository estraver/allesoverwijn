require 'uber/inheritable_attr'

# collection do
# where -> { joins(contents: :properties).where('properties.name = ? AND properties.value = ?', :published, true).distinct }
# where ['properties.name = ? AND properties.value = ?', :published, true]
# where do
#   and do
#     equals :name, :published
#     equals :value, true
#   end
# end
# where do
#   joins :contents do
#     joins: properties do
#       and do
#          name: :published
#          value: true
#       end
#     end
#   end
#   distinct
# end
#
# where :published
# order :published_on

# end

module Recollect
  class Collection
    require 'recollect/builder'
    extend Builder

    extend Uber::InheritableAttr
    inheritable_attr :extension
    inheritable_attr :body

    class << self
      def scope(body, &block)
        self.extension = Module.new(&block) if block
        self.body = body
      end
    end

    require 'recollect/setup'
    include Setup

    def call(*args)
      @collection ||= build_collection!(*args)
      self
    end

    def collection
      @collection
    end

    def count
      @collection.except(:limit, :offset).count
    end

    def model
      @model
    end

    private
    module ModelReaders
      attr_reader :body
      attr_reader :model
      attr_reader :params
      attr_reader :extension
      attr_reader :collection
    end
    include ModelReaders

  end
end