module AbstractPost::UserPost
 def content_by_model_and_user(model, user)
    @content ||= begin
      content = model.post_contents.find_by_locale(locale_for_user(user))
      content.nil? ? model.post_contents.first : content
    end
  end

  def value_by_model_and_user(model, field, user)
    content_by_model_and_user(model, user).send(field)
  end

  def locale_for_user(user)
    user.profile.language || I18n.locale || I18n.default_locale
  end

end