require_dependency 'profile/operations'

class User < ActiveRecord::Base
  class SignIn < Trailblazer::Operation
    include Model
    model User, :update

    contract do
      property :sign_in_count
      property :current_sign_in_at
      property :last_sign_in_at
    end

    def process(params)
      # assign_user! user
      sign_in!
      contract.save
    end

    private

    def sign_in!
      contract.sign_in_count += 1
      contract.last_sign_in_at = contract.current_sign_in_at
      contract.current_sign_in_at = DateTime.now
    end

    # def assign_user!(user)
    #   contract.sign_in_count = user.sign_in_count
    #   contract.last_sign_in_at = user.last_sign_in_at
    #   contract.current_sign_in_at  = user.current_sign_in_at
    # end
  end

  class Show < Trailblazer::Operation
    include Model
    model User, :find

    @new_profile = false

    def setup_model!(params)
      unless has_profile?
        @new_profile = true
        model.create_profile
      end
      # model.create_profile unless has_profile?
    end

    # def process(params)
    #
    # end

    def has_profile?
      !model.profile.nil?
    end

    def new_profile?
      # model.profile.new_record?
      @new_profile
    end

    private

  end

  class Mailer < Trailblazer::Operation
    include Model

    model User, :find

    contract do
      property :email
      property :email_template, virtual: true
      property :mailer, virtual: true
      property :deliver_method, virtual: true, default: 'later'

      validation :default do
        required(:email_template).filled
        required(:mailer).filled
        required(:deliver_method).filled(included_in?: %w(later now))
      end
    end

    def process(params)
      validate(params) do
        send!
      end
    end

    private

    def send!
      contract.mailer.send("#{contract.email_template}", contract.model).send("deliver_#{contract.deliver_method}")
    end

  end
end