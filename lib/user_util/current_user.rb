# require 'user_util/user_util'

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

    def find_current_user(user_id)
      @current_user ||= User.find(user_id)
    end
  end
end