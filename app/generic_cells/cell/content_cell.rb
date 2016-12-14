require 'uber/delegates'
require 'abstract_post/user_post'

module Cell
  module ContentCell
    extend Uber::Delegates

    delegates :model, :post, :picture_meta_data
    delegates :content, :article, :author, :title
    delegates :operation, :current_user, :policy?

    include Cell::DateCell.property :published_on
    include AbstractPost::UserPost

    private

    # attr_reader :operation
    # attr_reader :content

    def author_name
      author.name
    end

    def article_summary
      # truncate article, length: 30, separator: /\w/, omission: '&hellip;', escape: false
      # sanitize(sanitize(article)).truncate(length: 30, separator: /\w/, omission: '&hellip;')
      sanitize(sanitize(article)).truncate(150)
    end

    def published_on
      I18n.l(Date.parse(content.properties.find_by(name: :published_on).value))
    end

    # FIXME: Put in separate setup module
    # def setup!(model, options)
    #   @operation = options.fetch(:operation)
    #   @content ||= content_by_model_and_user(model.post, @operation.current_user)
    #   super
    # end

    private

    def content
      @content ||= content_by_model_and_user(model.post, context[:current_user])
    end

  end
end