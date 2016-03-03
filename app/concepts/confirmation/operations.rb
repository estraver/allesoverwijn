module Confirmation
  class Accept < Trailblazer::Operation
    include Model
    model User, :update

    contract do

      property :user_id, from: :id
      property :confirmation_token, virtual: true, validates: {presence: true}

      validate :token_ok?

      private

      def token_ok?
        @auth ||= Tyrant::Authenticatable.new(model)

        errors.add(:confirmation_token, _('confirmation.token.already_confirmed')) if @auth.confirmed?
        errors.add(:confirmation_token, _('confirmation.token.invalid_or_expired')) unless @auth.confirmable?(confirmation_token) && !@auth.confirmed?
      end
    end

    def process(params)
      validate(params) do
        confirmed!
        contract.save
      end
    end

    private

    def confirmed!
      @auth ||= Tyrant::Authenticatable.new(contract.model)
      @auth.confirmed!
      @auth.sync
    end
  end


end