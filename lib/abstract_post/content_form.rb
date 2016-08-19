# require 'reform/form/validation/unique_validator'
require 'html_counter'
require 'abstract_post/user_post'

module AbstractPost
  class ContentForm < Reform::Form
    include AbstractPost::UserPost

    property :title, virtual: true
    property :author, virtual: true
    property :locale, virtual: true
    property :article, virtual: true

    property :page

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
          counter = HtmlCounter.new
          Nokogiri::HTML::SAX::Parser.new(counter).parse(article)

          Rails.logger.info "article_2_lines?: #{counter.tag_count['p']} (#{counter.tag_count['p'] / 2 >= 1})"
          counter.tag_count['p'] / 2 >= 1
        end

        def article_10_words?(article)
          html = Nokogiri::HTML(article)
          Rails.logger.info "article_10_words?: #{html.to_str.scan(/\s+/).size} (#{html.to_str.scan(/\s+/).size >=  10})"
          html.to_str.scan(/\s+/).size >= 10
        end
      end
      required(:article).filled(:article_2_lines?, :article_10_words?)
    end

    # def article_length?
    #   counter = HtmlCounter.new
    #   Nokogiri::HTML::SAX::Parser.new(counter).parse(article)
    #
    #   errors.add(:article, 'activerecord.errors.messages.lines_too_short') unless counter.tag_count['p'] / 2 >= 1
    #
    #   html = Nokogiri::HTML(article)
    #   errors.add(:article, 'activerecord.errors.messages.words_too_short') unless html.to_str.scan(/\s+/).size < 10
    # end


    def prepopulate!(options)
      # def content_for_user(user)
      #   @content ||= begin
      #     content = self.model.post_contents.find_by_locale(locale_for(user))
      #     content.nil? ? self.model.post_contents.first : content
      #   end
      # end
      #
      # def default_for_user(user, field)
      #   content_for_user(user)[field]
      # end
      #
      # def locale_for(user)
      #   user.profile.language || I18n.locale || I18n.default_locale
      # end

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

    private

    # def get_post
    #   user = parent.current_user
    #   @post ||= begin
    #               # post = parent.post
    #     entry = post_contents.find_by(locale: locale_for(user))
    #
    #     if entry.nil?
    #       post_contents[0]
    #     else
    #       entry
    #     end
    #   end
    # end
    #
    # def default_content_for(prop)
    #   get_post.nil? ? nil : get_post.send(prop)
    # end
    #
    # def locale_for(user)
    #   user.profile.language || I18n.locale || I18n.default_locale
    # end

  end
end