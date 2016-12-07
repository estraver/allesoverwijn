require 'registration/authenticatable'
require 'mailer/mailer_callback'
require 'password_strength'

module Registration
  class SignUp < Trailblazer::Operation
    include Model, Callback
    model User, :create

    callback :after_save, MailerCallback::Confirmation

    contract do
      property :name
      property :email
      property :password, virtual: true
      property :password_confirmation, virtual: true
      collection :roles

      validation :default do
        required(:name).filled
        required(:email).filled
        required(:password).filled
        required(:password_confirmation).filled
      end

      validation :password_ok, if: :default do
        configure do
          option :form

          config.messages_file = 'config/dry_error_messages.yml'

          def password_strong?(password)
            password_strength = PasswordStrength::Base.new(form.name, password)
            password_strength.test
          end

        end

        required(:password_confirmation).filled
        required(:password).filled(:password_strong?)
        required(:password).filled(min_size?: 8).confirmation
      end

      validation :name_and_email, if: :password_ok do
        configure do
          option :form

          config.messages_file = 'config/dry_error_messages.yml'

          def unique_name?(name)
            User.where.not(id: form.model.id).find_by(name: name).nil?
          end

          def unique_email?(email)
            User.where.not(id: form.model.id).find_by(email: email).nil?
          end

        end

        required(:name).filled(:unique_name?)
        required(:email).filled(:unique_email?)
      end
    end

    def process(params)
      validate(params[:user]) do | contract |
        create!
        contract.save
        dispatch!(:after_save)
      end
    end

    private

    def create!
      @auth = Registration::Authenticatable.new(contract.model)
      @auth.digest!(contract.password)
      @auth.confirmable!
      @auth.sync

      contract.roles << Role.find_by_name(:standard)
    end

  end

  class ChangePassword < Trailblazer::Operation

  end

  class Delete < Trailblazer::Operation

  end

  class ResendConfirmationToken < Trailblazer::Operation
    include Model, Callback
    model User, :update

    callback :after_save, MailerCallback::Confirmation

    contract do
      property :auth_meta_data do
        property :confirmation_token
        property :confirmed_at
        property :confirmation_created_at
        property :confirmation_sent_at
        property :password_digest

        validation :default do
          required(:confirmation_sent_at).value(lt?: 2.weeks.ago)
          optional(:confirmed_at).value(:none?)
        end
      end
    end

    def process(params)
      validate(params) do | contract |
        confirmable!
        contract.save
        dispatch!(:after_save)
      end
    end

    private

    def setup_model!(*args)
      @auth = Registration::Authenticatable.new(contract.model)
    end

    def confirmable!
      @auth = Registration::Authenticatable.new(contract.model)
      @auth.confirmable!
      @auth.sync
    end
  end

  class Confirmation < Trailblazer::Operation
    include Model
    model User, :update

    def process(params)
      validate(params) do | contract |
        contract.save
      end
    end

    class Send < self
      contract do
        property :auth_meta_data do
          property :confirmation_sent_at

          validation :default do
            required(:confirmation_sent_at).filled
          end
        end
      end
    end
  end
end