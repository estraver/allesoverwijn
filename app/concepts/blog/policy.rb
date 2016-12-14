require 'application_policy'
require 'abstract_post/author_post'

class Blog::Policy < ApplicationPolicy
  include AbstractPost::AuthorPost

  def edit_and_owner?
    blog = content_by_model_and_user(@model.post, @user)
    edit? and @user.id == blog.author.id
  end

end