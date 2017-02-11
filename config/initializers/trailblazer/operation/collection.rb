require 'recollect/recollect'
require 'uber/inheritable_attr'

module Trailblazer::Operation::Collection

  def self.included(base)
    extend Uber::InheritableAttr
    base.inheritable_attr :collection_class
    base.inheritable_attr :collection_config
    base.collection_class = Recollect::Collection.clone

    base.extend Collection
  end

  module Collection
    def collection(name, options={}, &block)
      constant = options.delete(:collection)
      self.collection_config = options

      return collection_class unless constant or block_given?

      self.collection_class = Class.new(constant) unless constant.nil?
      collection_class.class_eval(&block) if block_given?

      define_method(name) do
        @collection
      end
    end
  end

  module Setup
    attr_reader :collection
    attr_reader :values

    def setup_params!(params)
      requested_params = self.class.collection_config[:params] || {}
      @values = requested_params.collect { | param | [param, params[param]] }
      super
    end

    def setup_model!(params)
      @collection ||= self.class.collection_class.new(model_class, params.to_unsafe_h).(*@values)
      super
    end
  end
  include Setup
end