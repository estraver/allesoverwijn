# require 'reform/form/validation/unique_validator'
# require 'html_counter'
require 'abstract_post/user_post'

module AbstractPost
  class ContentForm < Reform::Form
    include AbstractPost::UserPost

    property :title, virtual: true
    property :author, virtual: true
    property :locale, virtual: true
    property :article, virtual: true

    property :page

    collection :post_contents,
      populator: ->(fragment:, **) {
        item = post_contents.find { |content| content.locale == fragment['locale'].to_i }

        item ? item : posts_contents.append(PostContent.new)
      } do

      property :title
      property :author
      property :locale
      property :article
    end

    # property :current_user, virtual: true

    # property :tag_list, virtual: true
    # property :category_list, virtual: true

    property :tags, collection: true, virtual: true, default: [] do
      property :tag
    end

    collection :categories, default: [] do
      property :id
    end

    property :category_ids, virtual: true, default: []

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

      self.tags.from_collection(content_by_model_and_user(self.model, user).tags)
      # content_by_model_and_user(self.model, user).tags.each do | tag |
      #   self.tags << tag
      # end

    end

    def populator!(*args)
      Rails.logger.info args.inspect
    end

    private


  end
end