require 'uber/builder'
module Recollect::Collection::Builder
  def self.extended(extender)
    extender.send(:include, Uber::Builder)
  end

  def builder_class
    @builders
  end

  def builder_class=(constant)
    @builders = constant
  end

  private
  # Runs the builders for this operation class to figure out the actual class.
  def build_where_class(*args)
    class_builder(self).(*args) # Uber::Builder::class_builder(context)
  end

  def build_where(params, options={})
    build_where_class(params).new(params, options)
  end

end