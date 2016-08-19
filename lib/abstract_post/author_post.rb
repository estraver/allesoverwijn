require 'abstract_post/user_post'

module AbstractPost::AuthorPost
  include AbstractPost::UserPost

  def author_for_post(model, user)
    post = content_by_model_and_user(model, user)
    post.author
  end
end