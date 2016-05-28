require 'uber/delegates'

module Cell
  module ContentCell
    extend Uber::Delegates

    delegates :model, :post, :picture_meta_data
    delegates :post, :article, :author, :published_on, :title
    delegates :operation, :current_user, :policy?

    include Cell::DateCell.property :published_on

    private

    attr_reader :operation

    def author_name
      author.name
    end

    def article_summary
      truncate article, length: 30, separator: /\w/, omission: '&hellip;'
    end

    # FIXME: Put in separate setup module
    def setup!(model, options)
      @operation = options.delete(:operation)
      @options = options
      @model = AbstractPost::Entry.build(model, {current_user: current_user, properties: AbstractPost::PropertyType.find(model.class)})
    end
  end
end