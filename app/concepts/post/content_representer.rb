require 'representable/json'
require 'abstract_post/user_post'

class ContentRepresenter < Representable::Decorator
  include Representable::JSON
  include AbstractPost::UserPost

  property :title, getter: ->(represented:,user_options:,decorator:, **) {
    # Rails.logger.info self.inspect
    decorator.value_by_model_and_user(represented, :title, user_options[:current_user])
  }
  property :author, getter: ->(represented:,user_options:,decorator:,**) {
    decorator.value_by_model_and_user(represented, :author, user_options[:current_user])
  } do
    property :id
    property :name
  end
  property :locale, getter: ->(represented:,user_options:,decorator:,**) {
    decorator.value_by_model_and_user(represented, :locale, user_options[:current_user])
  }
  property :article, getter: ->(represented:,user_options:,decorator:,**) {
    decorator.value_by_model_and_user(represented, :article, user_options[:current_user])
  }

  collection :tags, getter: ->(represented:, user_options:, decorator:, **) {
    decorator.value_by_model_and_user(represented, :tags, user_options[:current_user])
  } do
    property :tag
  end

  property :page

  collection :post_contents do
    property :title
    property :author
    property :locale
    property :article

    collection :properties do
      property :name
      property :value
    end

    collection :tags do
      property :tag
    end
  end

  collection :categories do
    property :id
  end

  # FIXME: deserialize picture_meta_data
  # property :picture_meta_data #, deserializer: {writeable: false}

end