module CategoriesHelper
  def category_locale_options
    I18n.available_locales.map do |  locale |
      [locale, locale, data: {icon: "flag-icon flag-icon-#{locale} flag-width"}]
    end
  end
end
