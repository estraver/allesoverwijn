require_dependency('password_strength')
# require 'reform/form/validation/unique_validator.rb'

module Registration
  class SignUp < Trailblazer::Operation
    include Model
    model User, :create

    contract do
      property :name
      property :email
      property :password, virtual: true
      property :confirm_password, virtual: true
      collection :roles

      validation :default do
        key(:name).required
        key(:email).required
        key(:password).required
        key(:confirm_passwrod).required
      end

      validation :unique_name_and_email, if: :default do
        # FIXME
        # validates :name, unique: true
        # validates :email, unique: true

      end

      validation :password_ok, if: :unique_name_and_email do
        # validate :password_ok?
        key(:password).required(min_size?: 12).confirmation
      end
      # validates :name, :email, :password, :confirm_password, presence: true

      private

      # def password_ok?
      #   return unless email and password
      #   password_strength = PasswordStrength::Base.new(name, password)
      #   password_strength.test
      #   errors.add(:password, _('registration.new.no_matching_password')) if password != confirm_password
      #   errors.add(:password, _('registration.new.weak_password')) unless password_strength.valid?
      # end
    end

    def process(params)
      validate(params[:user]) do
        create!
        contract.save
        mail!
      end
    end

    private

    def create!
      @auth = Tyrant::Authenticatable.new(contract.model)
      @auth.digest!(contract.password)
      @auth.confirmable!
      @auth.sync

      contract.roles << Role.find_by_name(:standard)
    end

    def mail!
      @auth.send_confirmation RegistrationMailer.confirmation_instructions(contract.model)
      @auth.sync
      contract.save
    end
  end

  class Edit < Trailblazer::Operation

  end

  class Destroy < Trailblazer::Operation

  end
end