module Category::Cell
  class New < Trailblazer::Cell
    include SimpleForm::ActionViewExtensions::FormHelper
    include ActionView::RecordIdentifier
    include ActionView::Helpers::FormOptionsHelper

    def operation
      context[:operation]
    end

    def category_locale_options
      I18n.available_locales.map do |  locale |
        [locale, locale, data: {icon: "flag-icon flag-icon-#{locale} flag-width"}]
      end
    end

    def locale
      context[:current_user].profile.language || I18n.locale || I18n.default_locale
    end

  end
end