require 'abstract_post/user_post'
require 'user/user_form'

class ContentForm < Reform::Form
  include AbstractPost::UserPost

  property :title, virtual: true
  property :author, virtual: true, form: UserForm, populate_if_empty: ->(fragment:, **) {
    User.find_by(fragment[:id]) || User.new
  }
  property :locale, virtual: true
  property :article, virtual: true

  collection :tags, virtual: true

  property :page

  collection :post_contents,
    populator: ->(fragment:, **) {
      item = post_contents.find { | post_content | post_content.locale == fragment[:locale] }
      item ? item : post_contents.append(PostContent.new)
    } do

    property :title
    property :author, form: UserForm, populate_if_empty: ->(fragment:, **) {
      User.find_by(fragment[:id]) || User.new
    }
    property :locale
    property :article

    collection :properties, populator: ->(fragment:, **) {
      item = properties.find { | property | property.name == fragment[:name] }
      item ? item : properties.append(::Property.new)
    } do
      property :name
      property :value
    end

    collection :tags, populator: ->(fragment:, **) {
      item = tags.find { | tag | tag.tag == fragment[:tag] }
      item ? item : tags.append(Tag.find_by_tag(fragment[:tag]) || Tag.new)
    } do
      property :tag
    end
  end

  collection :categories, populator: ->(fragment:, **) {
    item = categories.find { | category | category.id == fragment[:id] }
    item ? item : categories.append(Category.find(fragment[:id]))
  } do
    property :id

    validation do
      configure do
        config.messages_file = 'config/dry_error_messages.yml'

        def category_exists?(id)
          !Category.where(id: id).nil?
        end

      end

      required(:id).filled(:category_exists?)
    end
  end

  # FIXME: deserialize picture_meta_data
  property :picture_meta_data #, deserializer: {writeable: false}

  validation :default do
    required(:title).filled
    required(:author).filled
    required(:locale).filled
    required(:article).filled
  end

  validation :locale, if: :default do
    required(:locale).value(included_in?: I18n.available_locales.map(&:to_s))
  end

  validation :title, if: ( :default and :locale ) do
    configure do
      option :form

      config.messages_file = 'config/dry_error_messages.yml'

      def unique_title?(title)
        PostContent.where.not(id: form.model.id).find_by(title: title, locale: form.locale).nil?
      end
    end

    required(:title).filled(:unique_title?)
 end

  validation :article, if: :default do
    configure do
      config.messages_file = 'config/dry_error_messages.yml'

      def article_2_lines?(article)
        node = Nokogiri::HTML.fragment(article)

        node.elements.inject(0) { | total, el | total + (el.name.eql?('p') ? 1 : 0) } >= 2
      end

      def article_10_words?(article)
        node = Nokogiri::HTML.fragment(article)
        node.elements.map { | el | el.text }.join(' ').scan(/\s+/).size >= 10
      end
    end
    required(:article).filled(:article_2_lines?, :article_10_words?)
  end

  def prepopulate!(options)
    user = User.find(options[:params][:current_user])

    %w(title author locale article).each do |field|
      self.send("#{field}=", value_by_model_and_user(self.model, field, user))
    end

    self.tags ||= []

    content_by_model_and_user(self.model, user).tags.each do | tag |
      self.tags << tag
    end

  end

  private


end