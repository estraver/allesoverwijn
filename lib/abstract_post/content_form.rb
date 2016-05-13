require 'reform/form/validation/unique_validator.rb'

module AbstractPost
  class ContentForm < Reform::Form
    property :title
    property :author
    property :locale
    property :article

    validation :default do
      validates :title,  presence: true, allow_blank: false
      validates :author, presence: true, allow_blank: false
      validates :locale, presence: true, allow_blank: false
      validates :article, presence: true, allow_blank: false
    end

    validation :locale, if: :default do
      validates :locale, inclusion: {in: I18n.available_locales.map(&:to_s)}
    end

    validation :title, if: ( :default and :locale ) do
      validate :unique_title?
    end

    def unique_title?
      PostContent.find_by_locale_and_title(locale, title).nil?
    end

    validation :article, if: :default do
      validates :article, length: {
                           minimum: 1,
                           tokenizer: ->(v) { v.scan(/\n/) }
                       }
      validates :article, length: {
                           minimum: 10,
                           tokenizer: ->(v) { v.scan(/\s+/) }
                       }

    end
  end
end