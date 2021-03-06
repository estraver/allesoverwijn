module Recollect::Collection::Setup
  def initialize(model, params = nil)
    @model = model
    @params = params
  end

  def build_collection!(*args)
    collection = retrieve_collection!(*args)
    collection = setup_collection!(collection, *args)
    collection = filter_collection!(collection, *args)
    collection
  end

  def retrieve_collection!(*args)
    scope = @model.all.scoping { @model.instance_exec *args, &self.class.body }
    scope = scope.extending(self.class.extension) if self.class.extension

    scope || all
  end

  def setup_collection!(collection, *args)
    collection
  end

  def filter_collection!(collection, *args)
    collection
  end
end