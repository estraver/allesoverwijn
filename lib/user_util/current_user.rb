module UserUtil
  module CurrentUser
    attr_reader :current_user

    private

    module Setup
      def setup!(params)
        find_current_user(params.fetch(:current_user))
        super
      end
    end
    include Setup

    def find_current_user(user)
      @current_user ||= begin
        user if user.is_a? User or user.is_a? Guest
        User.find(user_id)  if user.is_a? Fixnum
      end
    end
  end
end