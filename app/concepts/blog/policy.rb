require_dependency 'application_policy'
require_dependency 'abstract_post/author_post'

class Blog::Policy < ApplicationPolicy
  include AbstractPost::AuthorPost

  def edit_and_owner?
    blog = content_by_model_and_user(@model.post, User.find(@user_id))
    # blog = AbstractPost::Entry.build(@model, current_user: User.find(@user_id))
    edit? and @user_id == blog.author.id
  end

end

# Blog::Policy.extend AbstractPost::AuthorPost