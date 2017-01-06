require 'user_util/guest/profile'
require 'json'

module UserUtil
  module Guest
    class << self

      class Role < Struct.new(:name, :description, :role_meta_data)
      end

      def id
        nil
      end

      def name
        _('guest')
      end

      def roles
        @roles ||= begin
          Array.new(1) {
            Role.new('guest', nil, {blog: {show: true}})
          }
        end
      end

      def profile
        Guest::Profile
      end
    end
  end
end