require_dependency 'user/operations'

module Session
  class SignIn < Trailblazer::Operation
    # include Model
    # model User

    contract do
      property :email, virtual: true
      property :password, virtual: true
      property :remember_me, virtual: true

      validation :default do
        configure do
          option :form

          config.messages_file = 'config/dry_error_messages.yml'

          def password_ok?(password)
            user = User.find_by(email: form.email)
            user and Tyrant::Authenticatable.new(user).digest?(password)
          end

          def valid_email?(email)
            !User.find_by(email: email).nil?
          end

        end

        required(:email).filled(:valid_email?)
        required(:password).filled(:password_ok?)
      end

      private
    end

    def process(params)
      validate(params[:user]) do |contract|

        # @model = contract.user

        User::SignIn.(id: contract.model.id)
        # @route = root_path
        # @route = new_user_profile_path(@model) unless profile?
      end
    end

    private

    def model!(params)
      user = User.find_by(email: params[:user][:email]) if params.has_key? :user
      user || User.new
    end

  end

  class SignOut < Trailblazer::Operation
    def process(params)

    end
  end
end