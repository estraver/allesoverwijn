require_dependency 'disposable/twin/parent'
require_dependency 'disposable/twin/coercion'

module AbstractPost
  class Entry < Disposable::Twin
    feature Parent, Default
    feature Persisted, Changed
    feature Sync, Coercion
    include Builder

    class << self; attr_accessor :properties, :new_post_content; end

    builds ->(model, options) do
      entry_class = AbstractPost::Entry.clone
      properties = []
      properties |= options.delete(:properties) if options.key?(:properties)
      entry_class.class_eval <<-EOV
        property :post, inherit: true do
          properties.each do | property |
            property property.name, virtual: true, type: Kernel.const_get(property.type), default: -> { property_value_for(property.name) }
          end
        end

        self.properties = properties
      EOV
      entry_class
    end

    property :current_user, virtual: true

    property :id
    property :post, default: Post.new do
      property :page
      property :picture_meta_data

      collection :post_contents do
        property :title
        property :article
        property :locale
        property :author

        collection :properties do
          property :name
          property :value
        end

        collection :tags do
          property :id
          property :name
        end

      end

      collection :categories do
        property :id
      end

      property :title, virtual: true, default: -> { default_content_for(:title) }
      property :article, virtual: true, default: -> { default_content_for(:article) }
      property :locale, virtual: true, default: -> { default_content_for(:locale) }
      property :author, virtual: true, default: -> { default_content_for(:author) }

      property :tags, collection: true, virtual: true, default: -> { default_tags } do
        property :id
        property :name
      end

      private

      def get_post
        user = parent.current_user
        @post ||= begin
          # post = parent.post
          entry = post_contents.find_by(locale: locale_for(user))

          if entry.nil?
            post_contents[0]
          else
            entry
          end
        end
      end

      def default_content_for(prop)
        get_post.nil? ? nil : get_post.send(prop)
      end

      def locale_for(user)
        user.profile.language || I18n.locale || I18n.default_locale
      end

      def property_value_for(prop)
        post = get_post
        property = post.properties.find_by(name: prop) unless post.nil?
        property.nil? ? nil : property.value
      end

      def default_tags
        get_post.tags.each do | tag |
          tags << tag
        end
      end
    end

    module Content
      class ContentChange < Disposable::Callback::Group
        property :post do
          on_change :post_update!

          # on_change :post_update!, property: :locale
          # on_change :post_update!, property: :author
          # on_change :post_update!, property: :article

          private

          def post_update!(twin, options)
            entry = twin.post_contents.find_by(locale: twin.locale)

            if entry.nil?
              twin.post_contents.delete(twin.parent.class.new_post_content)
              twin.post_contents << PostContent.new(author: twin.author || twin.parent.current_user, locale: twin.locale, title: twin.title, article: twin.article)
              twin.parent.class.new_post_content = post.post_contents[post.post_contents.size - 1]
            else
              entry.title = twin.title if twin.changed?(:title)
              entry.article = twin.article if twin.changed?(:article)
              entry.author = twin.author if twin.changed?(:author)
              entry.locale = twin.locale if twin.changed?(:locale)
            end

            property_update!(twin, entry || twin.parent.class.new_post_content, options)

            tags_update!(twin, entry || twin.parent.class.new_post_content, options)
          end

          def property_update!(twin, entry, options)
            twin.parent.class.properties.each do | field |
              if twin.changed?(field.name)
                prop= entry.properties.find_by(name: field.name)
                if prop.nil?
                  entry.properties << Property.new(name: field.name, value: twin.send(field.name))
                else
                  prop.value = twin.send(field.name) if twin.changed?(field.name)
                end
              end
            end
          end

          def tags_update!(twin, entry, options)
            # Update or add new tag
            twin.tags.each do | tag |
              tagged = entry.tags.find_by(id: tag.id)
              if tagged then
                tagged.name = tag.name if tag.changed(:name)
              else
                entry.tags << tag
              end
            end

            # Delete tags
            entry.tags.each do | tag |
              tagged = twin.tags.find_by(id: tag.id)
              entry.tags.delete(tag) unless tagged
            end
          end

        end
      end
    end
    include Content
  end
end
