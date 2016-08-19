module Tyrant
  class Authenticatable < Disposable::Twin

    property :auth_meta_data, default: AuthMetaData.new do
      property :confirmation_token
      property :confirmed_at
      property :confirmation_created_at
      property :password_digest
      property :confirmation_sent_at
    end

    module Confirm
      def confirmable!
        auth_meta_data.confirmation_token = rand(36**36).to_s(36)
        auth_meta_data.confirmation_created_at = DateTime.now
        self
      end

      # without token, this decides whether the user model can be activated (e.g. via "set a password").
      # with token, this additionally tests if the token is correct.
      def confirmable?(token=false)
        persisted_token = auth_meta_data.confirmation_token

        return false unless (persisted_token.is_a?(String) and persisted_token.size > 0)
        return false unless auth_meta_data.confirmation_sent_at > 2.weeks.ago

        return compare_token(token) if token
        true
      end

      def send_confirmation(mailer)
        mailer.deliver_now!
        auth_meta_data.confirmation_sent_at = DateTime.now
      end
    end
  end
end