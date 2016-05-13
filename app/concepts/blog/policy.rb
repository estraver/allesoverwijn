require_dependency 'application_policy'

class Blog::Policy < ApplicationPolicy

  def edit_and_owner?
    edit? and @user_id == @model.post.author.id
  end

end