class ConfirmationMailObserver
  def self.delivered_email(message)

    Rails.logger.info 'delivering_email'

    filteredMailers = %w(RegistrationMailer)

    if filteredMailers.include?(message.delivery_handler.to_s)
      user = User.find_by_email(message.to)
      # auth = AuthMetaData.find_by_user_id(user.id)

      # AuthMetaData.update(auth.id, confirmation_sent_at: message.date)
       # auth.confirmation_sent_at= message.date
      # auth.save!
        Registration::Confirmation::Send.(id: user.id, auth_meta_data: { confirmation_sent_at: message.date })
    end

    return message
  end
end