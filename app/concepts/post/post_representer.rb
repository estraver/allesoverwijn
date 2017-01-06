require 'representable/json'
require 'post/content_representer'

class PostRepresenter < Representable::Decorator
  include Representable::JSON

  property :post, decorator: ContentRepresenter
  property :success, getter: ->(user_options:, **) { user_options[:success] }
end