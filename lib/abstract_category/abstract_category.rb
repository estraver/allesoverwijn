require_dependency 'disposable/twin/parent'
require_dependency 'disposable/twin/coercion'

module AbstractCategory
  class Entry < Disposable::Twin
    feature Default, Parent
    feature Persisted, Changed
    feature Sync, Coercion

    class << self; attr_accessor :new_name; end

    property :current_user, virtual: true

    property :id
    collection :category_names do
      property :name
      property :locale
    end

    # property :child_categories, twin: AbstractCategory::Entry, current_user: -> { current_user }, collection: true
    # property :parent_category, twin: AbstractCategory::Entry, current_user: -> { current_user }
    property :parent_category_id

    property :name, default: -> { default_name }
    property :locale, default: -> { default_locale }

    def child_categories
      self.model.child_categories.map do | child_category |
        AbstractCategory::Entry.new(child_category, current_user: current_user)
      end
    end

    private

    def category
      @category ||= begin
        entry = category_names.find_by(locale: locale_for(current_user))

        if entry.nil?
          category_names[0]
        else
          entry
        end
      end
    end

    def default_name
      category.nil? ? nil : category.name
    end

    def default_locale
      category.nil? ? nil : category.locale
    end

    def locale_for(user)
      user.profile.language || I18n.locale || I18n.default_locale
    end

    module Name
      class NameChange < Disposable::Callback::Group
        property :name do
          on_change :name_update!

          private

          def name_update!(twin, options)
            entry = twin.category_names.find_by(locale: twin.locale)

            if entry.nil?
              twin.category_names.delete(twin.parent.class.new_name)
              twin.category_names << CategoryName.new(name: twin.name, locale: twin.locale)
              twin.parent.class.new_name = category_names[category_names.size - 1]
            else
              entry.title = twin.name if twin.changed?(:name)
              entry.locale = twin.locale if twin.changed?(:locale)
            end

          end
        end
      end
    end
    include Name
  end
end
