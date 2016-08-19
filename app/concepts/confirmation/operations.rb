module Confirmation
  class Accept < Trailblazer::Operation
    include Model
    model User, :update

    contract do
      include Reform::Form::Dry

      property :user_id, from: :id
      property :confirmation_token, virtual: true

      validation :default do
        required(:confirmation_token).filled
      end

      validation :token, if: :default do
        configure do
          option :form

          config.messages_file = 'config/dry_error_messages.yml'

          def token_confirmed?
            @auth ||= Tyrant::Authenticatable.new(model)

            @auth.confirmed?
          end

          def token_expired?(confirmation_token)
            @auth ||= Tyrant::Authenticatable.new(model)

            !@auth.confirmable?(confirmation_token) && @auth.confirmed?
          end
        end

        required(:confirmation_token).filled(:token_confirmed?, :token_expired?)
      end

      private

      # def token_ok?
      #   @auth ||= Tyrant::Authenticatable.new(model)
      #
      #   errors.add(:confirmation_token, _('confirmation.token.already_confirmed')) if @auth.confirmed?
      #   errors.add(:confirmation_token, _('confirmation.token.invalid_or_expired')) unless @auth.confirmable?(confirmation_token) && !@auth.confirmed?
      # end
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