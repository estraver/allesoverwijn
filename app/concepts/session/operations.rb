require_dependency 'user/operations'

module Session
  class SignIn < Trailblazer::Operation
    include Model
    model User

    contract do
      attr_reader :user, :route

      property :email, virtual: true
      property :password, virtual: true
      property :remember_me, virtual: true

      validates :email, :password, presence: true
      validate :password_ok?

      # def self.to_s
      #   'Session'
      # end
      #
      # def self.base_class
      #   'Session'
      # end

      private

      def password_ok?
        return if email.blank? or password.blank?

        @user = User.find_by(email: email)
        errors.add(:password, _('session.new.no_matching_password')) unless @user and Tyrant::Authenticatable.new(@user).digest?(password)
      end
    end

    def process(params)
      validate(params[:user]) do |contract|

        @model = contract.user

        User::SignIn.(contract.user)
        # @route = root_path
        # @route = new_user_profile_path(@model) unless profile?
      end
    end

  end

  class SignOut < Trailblazer::Operation
    def process(params)

    end
  end
end