require_dependency 'abstract_post/content_form'
require_dependency 'abstract_post/properties'

module AbstractPost
  class PostForm < Reform::Form
    property :post, form: AbstractPost::ContentForm

    property :auto_schedule, virtual: true
  end
end