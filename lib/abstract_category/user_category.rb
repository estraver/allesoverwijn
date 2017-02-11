require 'abstract_category'

module AbstractCategory::UserCategory
  attr_reader :category

  def category_by_user(category, user)
    @category ||= begin
      category_name = category.category_names.find_by_locale(locale_for_user(user))
      category_name.nil? ? category.category_names.first : category_name
    end
  end

  def value_by_model_and_user(category, field, user)
    cat = category_by_user(category, user)
    cat.nil? ? nil : cat.send(field)
  end

  def locale_for_user(user)
    user.profile.language || I18n.locale || I18n.default_locale
  end

end