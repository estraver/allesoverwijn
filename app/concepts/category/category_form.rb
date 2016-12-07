require 'abstract_category/user_category'

class CategoryForm < Reform::Form
  include AbstractCategory::UserCategory

  property :name, virtual: true
  property :locale, virtual: true
  property :parent_category_id

  collection :child_categories do
    collection :category_names do
      property :name
      property :locale
    end

    property :name, virtual: true
    property :locale, virtual: true
  end

  collection :category_names,
             populator: ->(fragment:, **) {
               item = category_names.find { | category_name | category_name.locale == fragment[:locale] }
               item ? item : category_names.append(CategoryName.new)
             } do
    property :name
    property :locale
  end

  validation :default do
    required(:name).filled
    required(:locale).filled(included_in?: I18n.available_locales.map(&:to_s))
  end

  validation :name, if: :default do
    configure do
      option :form

      config.messages_file = 'config/dry_error_messages.yml'

      def unique_name?(name)
        CategoryName.where.not(id: form.model.id).find_by(name: name, locale: form.locale).nil?
      end
    end

    required(:name).filled(:unique_name?)
  end

  def prepopulate!(options)
    user = User.find(options[:params][:current_user])

    %w(name locale).each do |field|
      self.send("#{field}=", value_by_model_and_user(self.model, field, user))
    end

    # self.child_categories.class.current_user = user
    user_locale = locale_for_user(user)
    self.child_categories.each do | category |
      category.name = category.category_names.find_by(locale: user_locale).name
      category.locale = category.category_names.find_by(locale: user_locale).locale
    end
  end

end