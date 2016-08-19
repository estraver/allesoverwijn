class CategoryContract < Reform::Form
  property :name
  property :locale
  property :parent_category_id
  collection :child_categories, form: CategoryContract

  validation :default do
    # validates :name, presence: true, allow_blank: false
    # validates :locale, presence: true, allow_blank: false
    key(:name).required
    key(:locale).required
  end

end