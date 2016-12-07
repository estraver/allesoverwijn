require 'post/content_form'

class PostForm < Reform::Form
  property :post, form: ContentForm, populate_if_empty: Post
  property :scheduling, virtual: true
end