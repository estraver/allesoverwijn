require 'uber/inheritable_attr'

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

    def records
      @collection
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