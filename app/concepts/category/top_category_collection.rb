require_dependency 'abstract_category/abstract_category'
require_dependency 'recollect/recollect'
require_dependency 'recollect/twin'

class TopCategoryCollection < Recollect::Collection
  include Twin

  scope -> { where('parent_category_id IS NULL') }
  twin AbstractCategory::Entry
end