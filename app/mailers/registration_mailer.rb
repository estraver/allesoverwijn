class RegistrationMailer < ApplicationMailer
  def confirmation_instructions(user)
    @user = user
    @name = user.name
    @token = user.auth_meta_data.confirmation_token
    # @auth_meta_data = auth_meta_data
    email_with_name = %("#{@user.name}" <#{@user.email}>)
    mail(to: email_with_name, subject: AppConfig.registration.confirmation_subject % {site: AppConfig.site.title, domain: ActionMailer::Base.default_url_options[:host]})
  end
end
