module MailerCallback
  class Confirmation
    def initialize(contract)
      @contract = contract
    end

    def call(options)
      User::Mailer.(id: @contract.id, mailer: RegistrationMailer, email_template: 'confirmation_instructions')
    end
  end
end
