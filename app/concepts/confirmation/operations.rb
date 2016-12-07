require 'registration/authenticatable'

module Confirmation
  class Accept < Trailblazer::Operation
    include Model
    model User, :find

    contract do
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
            !Registration::Authenticatable.new(form.model).confirmed?
          end

          def token_invalid?(confirmation_token)
            Registration::Authenticatable.new(form.model).confirmable?(confirmation_token)
          end
        end

        required(:confirmation_token).filled(:token_confirmed?, :token_invalid?)
      end

      private

    end

    def process(params)
      validate(params) do
        confirmed!
        contract.save
      end
    end

    private

    def confirmed!
      @auth ||= Registration::Authenticatable.new(contract.model)
      @auth.confirmed!
      @auth.sync
    end
  end


end