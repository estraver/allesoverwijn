require_dependency 'category/operations'
require_dependency 'category/top_category_collection'

class CategoriesController < ApplicationController
  def new
    # FIXME: Put category collection in operation
    @collection = TopCategoryCollection.new(Category).().twinnize(current_user: current_user)
    form Category::Create
  end

  def create

  end
end
