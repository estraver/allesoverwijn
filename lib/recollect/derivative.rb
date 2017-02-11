require 'uber/inheritable_attr'

module Recollect::Collection::Derivative

  def self.included(base)
    extend Uber::InheritableAttr
    base.inheritable_attr :derivatives
    base.derivatives = {}

    base.extend Derivative
    base.extend Recollect::Collection::Setup
  end

  module Derivative
    def derivative(name, &block)
      self.derivatives[name] = block
    end
  end

  module Setup
    def initialize(model, params = nil)
      super(model, params)
      args = params.is_a?(ActionController::Parameters) ? params.to_unsafe_h : params
      self.class.derivatives.each do | name, block |
        model.send(:define_method, name) do
          # block.binding = self
          block.call(model: self, **args)
        end
        # mod = Module.new
        # mod.send(:define_method, name) do
        #   # self.instance_exec &block, **params
        #   self.instance_exec(**params) do
        #     block.call(**params)
        #   end
        #   # block.call(**params)
        # end
        # model.extend mod
      end

    end
  end

  include Setup

  private

end