require 'uber/inheritable_attr'
require 'disposable/twin'

module Recollect::Collection::Twin

  def self.included(base)
    extend Uber::InheritableAttr
    base.inheritable_attr :twin_class
    base.twin_class = Disposable::Twin.clone

    base.extend Twin
  end

  module Twin
    def twin(constant=nil, &block)
      return twin_class unless constant or block_given?

      self.twin_class = constant.clone unless constant.nil?
      twin_class.class_eval(&block) if block_given?
    end
  end

  def twinnize(options={})
    @collection.map { | model | twin_for(model, options) }
  end

  private

  def twin_for(model, options={})
    self.class.twin_class.build(model, options)
  end
end