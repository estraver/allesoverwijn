require_dependency 'profile/operations'

class Profile < ActiveRecord::Base
  module Contact
    class Create < Profile::Create
      include Model, Trailblazer::Operation::Policy

      model Profile, :create
      policy Profile::Policy, :create?

      contract do
        property :first_name
        property :middle_name
        property :last_name
        property :date_of_birth
        property :home
        property :birth_place
        property :gender
      end

    end

    class Update < Create
      builds -> (params) do
        JSON if params[:format] =~ 'json'
      end

      action :update

      policy Profile::Policy, :owner?

      contract do
        property :first_name
        property :middle_name
        property :last_name
        property :date_of_birth
        property :home
        property :birth_place
        property :gender

        validation :default do
          configure do
            config.messages_file = 'config/dry_error_messages.yml'

            def date_of_birth_ok?(date_of_birth)
              begin
                Date.parse(date_of_birth).to_s.eql? date_of_birth
              rescue ArgumentError
                false
              end
            end
          end

          required(:first_name).filled
          required(:last_name).filled
          required(:date_of_birth).filled(:date_of_birth_ok?)
        end

        private
      end

      def process(params)
        validate(params[:profile]) do | contract |
          contract.save
        end
      end

      class JSON < self
        # include Representer
        extend Representer::DSL
        include Representer::Rendering, Responder

        representer do
          property :first_name
          property :middle_name
          property :last_name
          property :date_of_birth
          property :home
          property :birth_place
          property :gender

          property :success, getter: ->(user_options:, **) { user_options[:success] }

        end
      end
    end

  end
end